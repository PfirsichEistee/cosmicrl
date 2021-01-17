
jobName = {
	[1] = "Bauarbeiter",
}


function getJobIdFromName(name)
	for a, b in ipairs(jobName) do
		if b == name then
			return a
		end
	end
end