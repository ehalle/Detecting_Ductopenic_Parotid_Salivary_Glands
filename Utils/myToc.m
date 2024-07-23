function [currentToc] = myToc()
    try
        currentToc = toc;
    catch
        currentToc = 0;
    end
end