`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [191:0] in;
    wire [191:0] out_1;
    wire [127:0] out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out_1(out_1),
        .out_2(out_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 192'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: All-zero input...");
            reset_dut();
            test_num = test_num + 1;


            in = 192'h0;

            @(posedge clk);
            #2;



            #1;




            check_outputs(
                192'h626363636263636362636363626363636263636362636363,
                128'h00000000000000000000000000000000
            );
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: All-ones input...");
            reset_dut();
            test_num = test_num + 1;

            in = {48{4'hf}};

            @(posedge clk);
            #2;




            #1;





            check_outputs(
                192'hE8E9E9E917161616E8E9E9E917161616E8E9E9E917161616,
                128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            );
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Linear sequence input...");
            reset_dut();
            test_num = test_num + 1;

            in = 192'h000102030405060708090a0b0c0d0e0f1011121314151617;

            @(posedge clk);
            #2;


            #1;



            check_outputs(
                192'h5846f2f95c43f4fe544afef55847f0fa4856e2e95c43f4fe,
                128'h000102030405060708090a0b0c0d0e0f
            );
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: FIPS-197 example vector...");
            reset_dut();
            test_num = test_num + 1;


            in = 192'h8e73b0f7da0e6452c810f32b809079e562f8ea3221035908;

            @(posedge clk);
            #2;


            #1;



            check_outputs(
                192'hf5b8170a2fb67358e7a680736736f99605ce13a424cd4aaa,
                128'h8e73b0f7da0e6452c810f32b809079e5
            );
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Alternating pattern...");
            reset_dut();
            test_num = test_num + 1;

            in = 192'h555555555555555555555555555555555555555555555555;

            @(posedge clk);
            #2;




            #1;





            check_outputs(
                192'ha8a9a9a9fdfcfcfca8a9a9a9fdfcfcfca8a9a9a9fdfcfcfc,
                128'h55555555555555555555555555555555
            );
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
        input [191:0] expected_out_1;
        input [127:0] expected_out_2;
        begin
            if (expected_out_1 === (expected_out_1 ^ out_1 ^ expected_out_1) &&
                expected_out_2 === (expected_out_2 ^ out_2 ^ expected_out_2)) begin
                $display("PASS");
                $display("  Outputs: out_1=%h, out_2=%h",
                         out_1, out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_1=%h, out_2=%h",
                         expected_out_1, expected_out_2);
                $display("  Got:      out_1=%h, out_2=%h",
                         out_1, out_2);
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
        $dumpvars(0,clk, in, out_1, out_2);
    end

endmodule
