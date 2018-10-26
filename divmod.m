function [division, remainder] = divmod(dividend, divisor)
    dividendCopy = dividend;
    divisorCopy  = divisor;
    dividendCopy = uint32(dividendCopy);
    divisorCopy  = uint32(divisorCopy);
    %cast(dividendCopy, 'uint32');
    %cast(divisorCopy,  'uint32');
    division  = idivide(dividendCopy, divisorCopy, 'floor');
    remainder = mod(dividendCopy, divisorCopy);
    cast(division,  'double');
    cast(remainder, 'double');
end

