`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] a_add_sel;
    reg [4:0] b_add_sel;
    reg clk_i;
    reg [4:0] w_add_i;
    reg [31:0] w_dat_i;
    reg write_en_i;
    wire [31:0] r_port_a_o;
    wire [31:0] r_port_b_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_add_sel(a_add_sel),
        .b_add_sel(b_add_sel),
        .clk_i(clk_i),
        .w_add_i(w_add_i),
        .w_dat_i(w_dat_i),
        .write_en_i(write_en_i),
        .r_port_a_o(r_port_a_o),
        .r_port_b_o(r_port_b_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            a_add_sel = 5'd0;
            b_add_sel = 5'd0;
            w_add_i = 5'd0;
            w_dat_i = 32'd0;
            write_en_i = 1'b0;

            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            w_add_i = 5'd1;
            w_dat_i = 32'hABCDE001;
            write_en_i = 1'b1;
            @(posedge clk_i);
            #1;
            write_en_i = 1'b0;


            a_add_sel = 5'd1;
            b_add_sel = 5'd1;
            #1;

            #1;


            check_outputs(32'hABCDE001, 32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Register 31 Protection", test_num);
            reset_dut();


            w_add_i = 5'd31;
            w_dat_i = 32'hFFFFFFFF;
            write_en_i = 1'b1;
            @(posedge clk_i);
            #1;
            write_en_i = 1'b0;


            a_add_sel = 5'd31;
            b_add_sel = 5'd31;
            #1;

            #1;


            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Verification", test_num);
            reset_dut();


            w_add_i = 5'd5;
            w_dat_i = 32'h55555555;
            write_en_i = 1'b1;
            @(posedge clk_i);
            #1;


            w_dat_i = 32'hAAAAAAAA;
            write_en_i = 1'b0;
            @(posedge clk_i);
            #1;


            a_add_sel = 5'd5;
            b_add_sel = 5'd5;
            #1;

            #1;


            check_outputs(32'h55555555, 32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Dual Port Independence", test_num);
            reset_dut();


            w_add_i = 5'd10;
            w_dat_i = 32'h10101010;
            write_en_i = 1'b1;
            @(posedge clk_i);
            #1;


            w_add_i = 5'd20;
            w_dat_i = 32'h20202020;
            write_en_i = 1'b1;
            @(posedge clk_i);
            #1;
            write_en_i = 1'b0;


            a_add_sel = 5'd10;
            b_add_sel = 5'd20;
            #1;

            #1;


            check_outputs(32'h10101010, 32'h20202020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Register 0 Boundary Check", test_num);
            reset_dut();


            w_add_i = 5'd0;
            w_dat_i = 32'h7FFFFFFF;
            write_en_i = 1'b1;
            @(posedge clk_i);
            #1;
            write_en_i = 1'b0;


            a_add_sel = 5'd0;
            b_add_sel = 5'd31;
            #1;

            #1;


            check_outputs(32'h7FFFFFFF, 32'h00000000);
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
        input [31:0] expected_r_port_a_o;
        input [31:0] expected_r_port_b_o;
        begin
            if (expected_r_port_a_o === (expected_r_port_a_o ^ r_port_a_o ^ expected_r_port_a_o) &&
                expected_r_port_b_o === (expected_r_port_b_o ^ r_port_b_o ^ expected_r_port_b_o)) begin
                $display("PASS");
                $display("  Outputs: r_port_a_o=%h, r_port_b_o=%h",
                         r_port_a_o, r_port_b_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_port_a_o=%h, r_port_b_o=%h",
                         expected_r_port_a_o, expected_r_port_b_o);
                $display("  Got:      r_port_a_o=%h, r_port_b_o=%h",
                         r_port_a_o, r_port_b_o);
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
        $dumpvars(0,a_add_sel, b_add_sel, clk_i, w_add_i, w_dat_i, write_en_i, r_port_a_o, r_port_b_o);
    end

endmodule
