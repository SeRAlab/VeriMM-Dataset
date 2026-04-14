`timescale 1ns/1ps

module Conv2D_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I00;
    reg [7:0] I01;
    reg [7:0] I10;
    reg [7:0] I11;
    reg [7:0] K00;
    reg [7:0] K01;
    wire [15:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Conv2D dut (
        .I00(I00),
        .I01(I01),
        .I10(I10),
        .I11(I11),
        .K00(K00),
        .K01(K01),
        .output_value(output_value)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Inputs and Kernels are Zero", test_num);
        I00 = 0; I01 = 0; I10 = 0; I11 = 0;
        K00 = 0; K01 = 0; K10 = 0; K11 = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single cell active", test_num);
        I00 = 8'd10; I01 = 0; I10 = 0; I11 = 0;
        K00 = 8'd5;  K01 = 0; K10 = 0; K11 = 0;
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Unit Kernels (Sum of Inputs)", test_num);
        I00 = 8'd1; I01 = 8'd2; I10 = 8'd3; I11 = 8'd4;
        K00 = 8'd1; K01 = 8'd1; K10 = 8'd1; K11 = 8'd1;
        #1;

        check_outputs(16'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Weighted Convolution", test_num);
        I00 = 8'd10; I01 = 8'd20; I10 = 8'd30; I11 = 8'd40;
        K00 = 8'd1;  K01 = 8'd2;  K10 = 8'd3;  K11 = 8'd4;

        #1;


        check_outputs(16'd300);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Max Product", test_num);
        I00 = 8'd255; I01 = 0; I10 = 0; I11 = 0;
        K00 = 8'd255; K01 = 0; K10 = 0; K11 = 0;

        #1;


        check_outputs(16'hFE01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Values (Truncation check)", test_num);
        I00 = 8'd255; I01 = 8'd255; I10 = 8'd255; I11 = 8'd255;
        K00 = 8'd255; K01 = 8'd255; K10 = 8'd255; K11 = 8'd255;


        #1;



        check_outputs(16'hF804);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Conv2D Testbench");
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
        input [15:0] expected_output_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h",
                         output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h",
                         expected_output_value);
                $display("  Got:      output_value=%h",
                         output_value);
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
