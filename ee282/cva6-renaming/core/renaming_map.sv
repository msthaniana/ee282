// Renaming map module
// While you are free to structure your implementation however you
// like, you are advised to only add code to the TODO sections
module renaming_map import ariane_pkg::*; #(
    parameter int unsigned ARCH_REG_WIDTH = 5,
    parameter int unsigned PHYS_REG_WIDTH = 6
)(
    // Clock and reset signals
    input logic clk_i,
    input logic rst_ni,

    // Indicator that there is a new instruction to rename
    input logic fetch_entry_ready_i,

    // Input decoded instruction entry from the ID stage
    input issue_struct_t issue_n,

    // Output instruction entry with registers renamed
    output issue_struct_t issue_q,

    // Destination register of the committing instruction
    input logic [PHYS_REG_WIDTH-1:0] waddr_i,
    
    // Indicator signal that there is a new committing instruction
    input logic we_gp_i
);

    // 32 architectural registers and 64 physical registers
    localparam ARCH_NUM_REGS = 2**ARCH_REG_WIDTH;
    localparam PHYS_NUM_REGS = 2**PHYS_REG_WIDTH;

    logic [PHYS_REG_WIDTH-1:0] rs1;
    logic [PHYS_REG_WIDTH-1:0] rs2;
    logic [PHYS_REG_WIDTH-1:0] rd;

    // TODO: ADD STRUCTURES TO EXECUTE REGISTER RENAMING
    
    // Function to calculate the lowest free reg
    // function automatic [5:0] update_lowest_free(input logic [63:0] free_map);
    //     // your priority encoder logic here
    // endfunction


    // 1. map: key is the rs number and value is the pr number. Default - map all arch regs to 0 (pr0)
    // 2. free: an array 64 deep. Each entry is 1 for free and 0 for not free.
    //         on every cycle that there is EITHER ALLOC or DEALLOC, using comb logic, recalculate the LOWEST free.
    // 3. dealloc: 
    //         write to dealloc list:
    //             on a new instr alloc, if there is a mapping already for rd, then add to dealloc
    //             key = newly allocated pr for dest reg, value = old address of pr
    //         consume from dealloc:
    //             on negedge whenever there is a new committing instr, index the dealloc map 
    //             if the entry is valid, then you need to deallocate that pr


    // Positive clock edge used for renaming new instructions
    always @(posedge clk_i, negedge rst_ni) begin
        // Processor reset: revert renaming state to reset conditions    
        if (~rst_ni) begin

            // TODO: ADD LOGIC TO RESET RENAMING STATE
            // 1. free = {pr1-pr63}
            //      logic [can_point_to_any_reg_width] current_lowest_free;
            // 2. map = {all arch regs = 0}
            // 3. dealloc = {all entries invalid}

    
        // New incoming valid instruction to rename   
        end else if (fetch_entry_ready_i && issue_n.valid) begin
            // Get values of registers in new instruction
            rs1 = issue_n.sbe.rs1[PHYS_REG_WIDTH-1:0];
            rs2 = issue_n.sbe.rs2[PHYS_REG_WIDTH-1:0];
            rd = issue_n.sbe.rd[PHYS_REG_WIDTH-1:0];

            // Set outgoing instruction to incoming instruction without
            // renaming by default. Keep this line since all fields of the 
            // incoming issue_struct_t should carry over to the output
            // except for the register values, which you may rename below
            issue_q = issue_n;

            // TODO: ADD LOGIC TO RENAME OUTGOING INSTRUCTION
            // The registers of the outgoing instruction issue_q can be set like so:
            // issue_q.sbe.rs1[PHYS_REG_WIDTH-1:0] = your new rs1 register value;
            // issue_q.sbe.rs2[PHYS_REG_WIDTH-1:0] = your new rs2 register value;
            // issue_q.sbe.rd[PHYS_REG_WIDTH-1:0] = your new rd register value;

            // 1. issue_q.sbe.rs1[PHYS_REG_WIDTH-1:0] = map[rs1];
            // 2. issue_q.sbe.rs2[PHYS_REG_WIDTH-1:0] = map[rs2];
            // 3. issue_q.sbe.rd[PHYS_REG_WIDTH-1:0]  = current_lowest_free;
            //                                         then run the function to recalculate current_lowest_free


    
        // If there is no new instruction this clock cycle, simply pass on the
        // incoming instruction without renaming
        end else begin
            issue_q = issue_n;
        end
    end
    

    // Negative clock edge used for physical register deallocation 
    always @(negedge clk_i) begin
        if (rst_ni) begin
            // If there is a new committing instruction and its prd is not pr0,
            // execute register deallocation logic to reuse physical registers
            if (we_gp_i && waddr_i != 0) begin
        
                // TODO: IMPLEMENT REGISTER DEALLOCATION LOGIC    
                // 1. When to dealloc? index dealloc_map[waddr_i].valid == 1 ? Then dealloc the reg: dealloc_map[waddr_i].old_pr
                // 2. on dealloc, run the function to recalculate current_lowest_free

            end
        end
    end
endmodule
