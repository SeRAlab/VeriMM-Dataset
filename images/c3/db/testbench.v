`timescale 1ns/1ps

module max_value_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_value dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A is the largest value", test_num);
        A = 8'd200; B = 8'd150; C = 8'd100; D = 8'd50;
        #1;

        check_outputs(16'd200);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: B is the largest value", test_num);
        A = 8'd10; B = 8'd250; C = 8'd30; D = 8'd40;
        #1;

        check_outputs(16'd250);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: C is the largest value", test_num);
        A = 8'd5; B = 8'd10; C = 8'd128; D = 8'd0;
        #1;

        check_outputs(16'd128);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: D is the largest value", test_num);
        A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd255;
        #1;

        check_outputs(16'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple inputs have the same maximum (A and B)", test_num);
        A = 8'd180; B = 8'd180; C = 8'd90; D = 8'd45;
        #1;

        check_outputs(16'd180);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple inputs have the same maximum (C and D)", test_num);
        A = 8'd10; B = 8'd20; C = 8'd100; D = 8'd100;
        #1;

        check_outputs(16'd100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs are the same", test_num);
        A = 8'd77; B = 8'd77; C = 8'd77; D = 8'd77;
        #1;

        check_outputs(16'd77);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs are zero", test_num);
        A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max value is 255 at multiple positions", test_num);
        A = 8'd255; B = 8'd0; C = 8'd255; D = 8'd128;
        #1;

        check_outputs(16'd255);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random distribution", test_num);
        A = 8'd42; B = 8'd13; C = 8'd101; D = 8'd88;
        #1;

        check_outputs(16'd101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_value Testbench");
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
