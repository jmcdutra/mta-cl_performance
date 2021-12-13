Class = { };

local function classMetatable( class, super )

	local class = class;
	local super = super;

	-- methods;

	rawset( super, "__mode", "k" );
	rawset( super, "__parent", class );
	rawset( super, "__super", super );

	super.__call = function( instance, superclass )

		rawset( instance, "__class", class );
		rawset( instance, "__base", superclass );

		return setmetatable( instance, { __index = superclass } );

	end

	super.__index = function( instance, key )

		if ( tostring( key ):match( "^__.+__$" ) ) then

			return;

		end

		if ( rawget( instance, key ) ~= nil ) then

			return rawget( instance, key );

		end

	end

	super.__newindex = function( instance, k, v )

		if ( instance.setattr__ ) then

			return instance:setattr__( k, v );

		else

			return rawset( instance, k, v );

		end

	end

	super.__tostring = function( )

		return super.getClassName( );

	end

	-- end methods;

	setmetatable( class, super );

	return class, super;

end

local function addClass( class, super )

	local class, super = classMetatable( class, super );
	rawset( class, "superclass", super );

	-- superclass;

	super.setClassName = function( name )

		if ( name ) then

			_G[ name ] = class;

			if ( not super.getClassName( ) ) then

				rawset( class, "__name", _G[ name ] );

			end

			rawset( super, "__name", _G[ name ] );

		end

	end

	super.setNewNameForClass = function( old_name, new_name )

		if ( old_name and new_name ) then

			if ( _G[ old_name ] ~= nil ) then

				_G[ old_name ] = nil;

			end

			_G[ new_name ] = class;

		end

		return class;

	end

	super.getIndexSuperclass = function( )

		return super.__index;

	end

	super.getSuperclass = function( )

		return rawget( class, "superclass" );

	end

	super.getClassName = function( )

		return rawget( class, "__name" );

	end

	-- end superclass;

	return class;

end

function class( name )

	local class = addClass( { }, Class );

	if ( name ) then

		class.superclass.setClassName( name );

	end

	return class;

end

-- async;

class "async" { 

	time_interval = 500;

	addThread = function( call )

		Async.thread = coroutine.create( call );
		Async.is_running = false;

	end,

	resume = function( )

		if ( coroutine.status( Async.thread ) == "suspended" ) then

			coroutine.resume( Async.thread );

		else

			if ( isTimer( Async.timer ) ) then

				killTimer( Async.timer );
				Async.timer = nil;

			end

			Async.is_running = false;

		end

		collectgarbage( "collect" );

	end,

	perform = function( )

		if ( Async.is_running ) then

			return;

		end

		Async.is_running = true;
		Async.timer = setTimer( Async.resume, Async.time_interval, 0 );

	end,

	iterate = function( self, from, to, call )

		self.addThread( function( ) 

			for i = from, to do

				call( i, i == to and true or false );
				coroutine.yield( );

			end

		end );

		self.perform( );

	end,

	foreach = function( self, tbl, mode, call )

		self.addThread( function( ) 

			for k, v in _G[ mode and "iparis" or "pairs" ]( tbl ) do

				call( k, v );
				coroutine.yield( );

			end

		end );

		self.perform( );

	end,

	switch = function( self, interge )

		local superclass = { };

		-- methods;

		superclass.__call = function( instance, class )

			rawset( instance, "__class", class );
			rawset( instance, "__interge", interge );

			if ( rawget( instance, "__interge" ) ~= false ) then

				if ( rawget( instance, "__class" ).case[ rawget( instance, "__interge" ) ] ) then

					rawget( instance, "__class" ).case[ rawget( instance, "__interge" ) ]( );

				else

					rawget( instance, "__class" ).default( );

				end

			end

			return instance;

		end

		-- end methods;

		return setmetatable( { class = self, super = self.superclass }, superclass );

	end

} async.superclass.getSuperclass( );

-- end async;