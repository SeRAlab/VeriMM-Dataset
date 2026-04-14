`timescale 1ns/1ps

module cop_wb_bus_tb;

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
    wire [4:0] write_regs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cop_wb_bus dut (
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
            wb_rst_i = 1;
            arst_i = 0;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            wb_adr_i = 0;
            wb_dat_i = 0;
            wb_sel_i = 2'b11;
            irq_source = 0;
            read_regs = 48'hFEDC_BA98_7654;
            @(posedge wb_clk_i);
            wb_rst_i = 0;
            @(posedge wb_clk_i);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking Asynchronous Reset Output");
            reset_dut();
            arst_i = 1;
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 16'h0000, 5'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking Synchronous Reset Output");
            reset_dut();
            wb_rst_i = 1;
            @(posedge wb_clk_i);
            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0, 16'h0000, 5'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Read from Address 0 (bits 15:0)");
            reset_dut();
            read_regs = 48'hAAAA_BBBB_CCCC;
            wb_adr_i = 3'd0;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            @(posedge wb_clk_i);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 16'hCCCC, 5'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Read from Address 1 (bits 31:16)");
            reset_dut();
            read_regs = 48'hAAAA_BBBB_CCCC;
            wb_adr_i = 3'd1;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            @(posedge wb_clk_i);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 16'hBBBB, 5'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Read from Address 2 (bits 47:32)");
            reset_dut();
            read_regs = 48'hAAAA_BBBB_CCCC;
            wb_adr_i = 3'd2;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            @(posedge wb_clk_i);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 16'hAAAA, 5'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Write to Address 0");
            reset_dut();
            wb_adr_i = 3'd0;
            wb_dat_i = 16'h1234;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 1;
            @(posedge wb_clk_i);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 16'h0000, 5'b00001);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Write to Address 4");
            reset_dut();
            wb_adr_i = 3'd4;
            wb_dat_i = 16'h5678;
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 1;
            @(posedge wb_clk_i);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 16'h0000, 5'b10000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Idle Bus (No STB)");
            reset_dut();
            wb_adr_i = 3'd0;
            wb_cyc_i = 1;
            wb_stb_i = 0;
            wb_we_i  = 1;
            @(posedge wb_clk_i);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 16'h0000, 5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cop_wb_bus Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [4:0] expected_write_regs;
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
