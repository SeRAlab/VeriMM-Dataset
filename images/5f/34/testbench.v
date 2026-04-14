`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    reg [15:0] in3;
    reg [15:0] in4;
    reg reset;
    wire [15:0] out1;
    wire [15:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .reset(reset),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset logic verification", test_num);

        reset = 1;
        in1 = 16'hFFFF;
        in2 = 16'hFFFF;
        in3 = 16'hFFFF;
        in4 = 16'hFFFF;


        #1;



        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal operation - Basic bitwise logic", test_num);

        reset = 1;
        #5;
        reset = 0;

        in1 = 16'h00FF;
        in2 = 16'h0F0F;
        in3 = 16'hF0F0;
        in4 = 16'hAAAA;




        #1;





        check_outputs(16'h000F, 16'h5A5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Edge case - All ones", test_num);
        reset = 1;
        #5;
        reset = 0;

        in1 = 16'hFFFF;
        in2 = 16'hFFFF;
        in3 = 16'hFFFF;
        in4 = 16'hFFFF;




        #1;





        check_outputs(16'hFFFF, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Edge case - All zeros", test_num);
        reset = 1;
        #5;
        reset = 0;

        in1 = 16'h0000;
        in2 = 16'h0000;
        in3 = 16'h0000;
        in4 = 16'h0000;




        #1;





        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Complementary bit patterns", test_num);
        reset = 1;
        #5;
        reset = 0;

        in1 = 16'hAAAA;
        in2 = 16'h5555;
        in3 = 16'hAAAA;
        in4 = 16'h5555;




        #1;





        check_outputs(16'h0000, 16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Mix of logic and late reset", test_num);
        reset = 0;
        in1 = 16'h1234;
        in2 = 16'hFFFF;
        in3 = 16'h1234;
        in4 = 16'h0000;


        reset = 1;


        #1;



        check_outputs(16'h0000, 16'h0000);
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
        input [15:0] expected_out1;
        input [15:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
