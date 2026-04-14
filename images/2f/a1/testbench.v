`timescale 1ns/1ps

module neural_layer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] b;
    reg [7:0] w1;
    reg [7:0] w2;
    reg [7:0] x1;
    reg [7:0] x2;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_layer dut (
        .b(b),
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs and weights zero", test_num);
        x1 = 8'd0; x2 = 8'd0; w1 = 8'd0; w2 = 8'd0; b = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple weighted sum within range", test_num);
        x1 = 8'd10; w1 = 8'd2;
        x2 = 8'd20; w2 = 8'd3;
        b  = 8'd5;
        #1;

        check_outputs(8'd85);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ReLU clipping negative sum to zero", test_num);
        x1 = 8'd5;  w1 = 8'd2;
        x2 = 8'd0;  w2 = 8'd0;
        b  = 8'b11101100;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sum exceeding 8-bit range (Saturation)", test_num);
        x1 = 8'd200; w1 = 8'd2;
        x2 = 8'd100; w2 = 8'd2;
        b  = 8'd10;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bias only influence", test_num);
        x1 = 8'd0; w1 = 8'hFF;
        x2 = 8'd0; w2 = 8'hFF;
        b  = 8'd127;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High weights with small inputs", test_num);
        x1 = 8'd2;   w1 = 8'd100;
        x2 = 8'd1;   w2 = 8'd50;
        b  = 8'd0;
        #1;

        check_outputs(8'd250);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_layer Testbench");
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
