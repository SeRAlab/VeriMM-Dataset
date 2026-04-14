`timescale 1ns/1ps

module pit_wb_bus_tb;

    // Testbench signals (sequential circuit)
    reg arst_i;
    reg irq_source;
    reg [47:0] read_regs;
    reg [2:0] wb_adr_i;
    reg wb_clk_i;
    reg wb_cyc_i;
    reg [15:0] wb_dat_i;
    reg wb_rst_i;
    reg [1:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire async_rst_b;
    wire sync_reset;
    wire wb_ack_o;
    wire [15:0] wb_dat_o;
    wire [3:0] write_regs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pit_wb_bus dut (
        .arst_i(arst_i),
        .irq_source(irq_source),
        .read_regs(read_regs),
        .wb_adr_i(wb_adr_i),
        .wb_clk_i(wb_clk_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_rst_i(wb_rst_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .async_rst_b(async_rst_b),
        .sync_reset(sync_reset),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o),
        .write_regs(write_regs)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            arst_i = ARST_LVL;
            wb_rst_i = 1;
            irq_source = 0;
            read_regs = 0;
            clear_bus();
            #20;
            arst_i = ~ARST_LVL;
            @(posedge wb_clk_i);
            wb_rst_i = 0;
            @(posedge wb_clk_i);
        end
        endtask
    task clear_bus;

        begin
            wb_cyc_i <= 0;
            wb_stb_i <= 0;
            wb_we_i  <= 0;
            wb_adr_i <= 0;
            wb_dat_i <= 0;
            wb_sel_i <= 2'b00;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 16'h0000, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reading Register 0", test_num);
            reset_dut();
            read_regs = 48'hAAAA_BBBB_CCCC;
            @(posedge wb_clk_i);
            wb_adr_i = 3'b000;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            wb_sel_i = 2'b11;
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 16'hCCCC, 4'h0);
            @(posedge wb_clk_i);
            clear_bus();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reading Register 1", test_num);
            reset_dut();
            read_regs = 48'hAAAA_BBBB_CCCC;
            @(posedge wb_clk_i);
            wb_adr_i = 3'b001;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            wb_sel_i = 2'b11;
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 16'hBBBB, 4'h0);
            @(posedge wb_clk_i);
            clear_bus();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Writing Register 0", test_num);
            reset_dut();
            @(posedge wb_clk_i);
            wb_adr_i = 3'b000;
            wb_dat_i = 16'h1234;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 1;
            wb_sel_i = 2'b11;
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 16'hzzzz, 4'h1);
            @(posedge wb_clk_i);
            clear_bus();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Writing Register 3", test_num);
            reset_dut();
            @(posedge wb_clk_i);
            wb_adr_i = 3'b011;
            wb_dat_i = 16'h5678;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 1;
            wb_sel_i = 2'b11;
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 16'hzzzz, 4'h8);
            @(posedge wb_clk_i);
            clear_bus();
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Cycle active, Strobe inactive", test_num);
            reset_dut();
            @(posedge wb_clk_i);
            wb_adr_i = 3'b000;
            wb_cyc_i = 1;
            wb_stb_i = 0;
            wb_we_i  = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 16'hzzzz, 4'h0);
            @(posedge wb_clk_i);
            clear_bus();
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Asynchronous Reset Assertion", test_num);
            reset_dut();
            arst_i = ARST_LVL;
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 16'h0000, 4'h0);
            arst_i = ~ARST_LVL;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pit_wb_bus Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_async_rst_b;
        input expected_sync_reset;
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        input [3:0] expected_write_regs;
        begin
            if (expected_async_rst_b === (expected_async_rst_b ^ async_rst_b ^ expected_async_rst_b) &&
                expected_sync_reset === (expected_sync_reset ^ sync_reset ^ expected_sync_reset) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o) &&
                expected_write_regs === (expected_write_regs ^ write_regs ^ expected_write_regs)) begin
                $display("PASS");
                $display("  Outputs: async_rst_b=%b, sync_reset=%b, wb_ack_o=%b, wb_dat_o=%h, write_regs=%h",
                         async_rst_b, sync_reset, wb_ack_o, wb_dat_o, write_regs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: async_rst_b=%b, sync_reset=%b, wb_ack_o=%b, wb_dat_o=%h, write_regs=%h",
                         expected_async_rst_b, expected_sync_reset, expected_wb_ack_o, expected_wb_dat_o, expected_write_regs);
                $display("  Got:      async_rst_b=%b, sync_reset=%b, wb_ack_o=%b, wb_dat_o=%h, write_regs=%h",
                         async_rst_b, sync_reset, wb_ack_o, wb_dat_o, write_regs);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,arst_i, irq_source, read_regs, wb_adr_i, wb_clk_i, wb_cyc_i, wb_dat_i, wb_rst_i, wb_sel_i, wb_stb_i, wb_we_i, async_rst_b, sync_reset, wb_ack_o, wb_dat_o, write_regs);
    end

endmodule
