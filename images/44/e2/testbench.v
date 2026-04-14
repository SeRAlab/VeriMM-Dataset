`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] mulcand;
    reg [2:0] r4input;
    reg sign;
    wire [33:0] pp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mulcand(mulcand),
        .r4input(r4input),
        .sign(sign),
        .pp(pp)
    );
    task testcase001;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h00000001; r4input = 3'b001; sign = 0;
        #1;

        check_outputs(34'h000000001);
    end
        endtask

    task testcase002;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h00000001; r4input = 3'b011; sign = 0;
        #1;

        check_outputs(34'h000000002);
    end
        endtask

    task testcase003;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h00000001; r4input = 3'b101; sign = 0;

        #1;


        check_outputs(34'h3FFFFFFFE);
    end
        endtask

    task testcase004;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h00000001; r4input = 3'b100; sign = 0;

        #1;


        check_outputs(34'h3FFFFFFFD);
    end
        endtask

    task testcase005;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'hFFFFFFFF; r4input = 3'b000; sign = 1;
        #1;

        check_outputs(34'h000000000);
    end
        endtask

    task testcase006;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h80000000; r4input = 3'b010; sign = 1;

        #1;


        check_outputs(34'h380000000);
    end
        endtask

    task testcase007;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h80000000; r4input = 3'b011; sign = 1;

        #1;


        check_outputs(34'h300000000);
    end
        endtask

    task testcase008;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h80000000; r4input = 3'b110; sign = 1;

        #1;


        check_outputs(34'h07FFFFFFF);
    end
        endtask

    task testcase009;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h55555555; r4input = 3'b011; sign = 0;

        #1;


        check_outputs(34'h0AAAAAAAA);
    end
        endtask

    task testcase010;

    begin
        mulcand = 0; r4input = 0; sign = 0;
        #10;
        mulcand = 32'h12345678; r4input = 3'b111; sign = 0;
        #1;

        check_outputs(34'h000000000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [33:0] expected_pp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pp === (expected_pp ^ pp ^ expected_pp)) begin
                $display("PASS");
                $display("  Outputs: pp=%h",
                         pp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pp=%h",
                         expected_pp);
                $display("  Got:      pp=%h",
                         pp);
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

endmodule
