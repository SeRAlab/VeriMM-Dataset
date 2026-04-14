`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg wb_clk_i;
    reg wb_cyc_i;
    reg [31:0] wb_dat_i;
    reg wb_rst_i;
    reg [3:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [31:0] port_output;
    wire wb_ack_o;
    wire [31:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_clk_i(wb_clk_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_rst_i(wb_rst_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .port_output(port_output),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        wb_clk_i = 0;
        forever #5 wb_clk_i = ~wb_clk_i;
    end

        task reset_dut;

        begin
            wb_rst_i = 1;
            wb_clk_i = 0;
            wb_cyc_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            wb_sel_i = 0;
            wb_dat_i = 0;
            #10;
            wb_rst_i = 0;
            @(posedge wb_clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();


            #1;



            check_outputs(32'h00000000, 1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Full 32-bit Write Operation", test_num);
            reset_dut();

            @(negedge wb_clk_i);
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 1;
            wb_sel_i = 4'b1111;
            wb_dat_i = 32'hDEADBEEF;

            @(posedge wb_clk_i);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 1'b1, 32'hDEADBEEF);

            wb_stb_i = 0;
            wb_cyc_i = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Selective Byte Write (0 and 2)", test_num);
            reset_dut();


            @(negedge wb_clk_i);
            wb_cyc_i = 1; wb_stb_i = 1; wb_we_i = 1; wb_sel_i = 4'b1111;
            wb_dat_i = 32'hFFFFFFFF;
            @(posedge wb_clk_i);


            @(negedge wb_clk_i);
            wb_dat_i = 32'h00000000;
            wb_sel_i = 4'b0101;
            @(posedge wb_clk_i);
            #2;


            #1;



            check_outputs(32'hFF00FF00, 1'b1, 32'hFF00FF00);

            wb_stb_i = 0;
            wb_cyc_i = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Verification", test_num);
            reset_dut();

            @(negedge wb_clk_i);
            wb_cyc_i = 1;
            wb_stb_i = 1;
            wb_we_i  = 0;
            wb_sel_i = 4'b1111;
            wb_dat_i = 32'hCAFEBABE;

            @(posedge wb_clk_i);
            #2;


            #1;



            check_outputs(32'h00000000, 1'b1, 32'h00000000);

            wb_stb_i = 0;
            wb_cyc_i = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Strobe Signal Verification", test_num);
            reset_dut();

            @(negedge wb_clk_i);
            wb_cyc_i = 1;
            wb_stb_i = 0;
            wb_we_i  = 1;
            wb_sel_i = 4'b1111;
            wb_dat_i = 32'h12345678;

            @(posedge wb_clk_i);
            #2;

            #1;


            check_outputs(32'h00000000, 1'b0, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Persistence and Read Operation", test_num);
            reset_dut();


            @(negedge wb_clk_i);
            wb_cyc_i = 1; wb_stb_i = 1; wb_we_i = 1; wb_sel_i = 4'b1111;
            wb_dat_i = 32'hA5A55A5A;
            @(posedge wb_clk_i);


            @(negedge wb_clk_i);
            wb_stb_i = 0; wb_we_i = 0;
            @(posedge wb_clk_i);
            #2;


            #1;



            check_outputs(32'hA5A55A5A, 1'b0, 32'hA5A55A5A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Selective Byte Write (1 and 3)", test_num);
            reset_dut();


            @(negedge wb_clk_i);
            wb_cyc_i = 1; wb_stb_i = 1; wb_we_i = 1; wb_sel_i = 4'b1111;
            wb_dat_i = 32'h00000000;
            @(posedge wb_clk_i);


            @(negedge wb_clk_i);
            wb_dat_i = 32'hFF00FF00;
            wb_sel_i = 4'b1010;
            @(posedge wb_clk_i);
            #2;


            #1;



            check_outputs(32'hFF00FF00, 1'b1, 32'hFF00FF00);

            wb_stb_i = 0;
            wb_cyc_i = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_port_output;
        input expected_wb_ack_o;
        input [31:0] expected_wb_dat_o;
        begin
            if (expected_port_output === (expected_port_output ^ port_output ^ expected_port_output) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: port_output=%h, wb_ack_o=%b, wb_dat_o=%h",
                         port_output, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: port_output=%h, wb_ack_o=%b, wb_dat_o=%h",
                         expected_port_output, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      port_output=%h, wb_ack_o=%b, wb_dat_o=%h",
                         port_output, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,wb_clk_i, wb_cyc_i, wb_dat_i, wb_rst_i, wb_sel_i, wb_stb_i, wb_we_i, port_output, wb_ack_o, wb_dat_o);
    end

endmodule
