`timescale 1ns/1ps

module adc_24bit_mux_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] input0;
    reg [23:0] input1;
    reg [23:0] input2;
    reg [1:0] select;
    wire [23:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24bit_mux dut (
        .input0(input0),
        .input1(input1),
        .input2(input2),
        .select(select),
        .output_value(output_value)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 0 (Normal)", test_num);
        input0 = 24'h123456;
        input1 = 24'h0000AA;
        input2 = 24'h0000BB;
        select = 2'b00;

        #1;


        check_outputs(24'h123456);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 1 (Normal)", test_num);
        input0 = 24'h0000CC;
        input1 = 24'h654321;
        input2 = 24'h0000DD;
        select = 2'b01;

        #1;


        check_outputs(24'h654321);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 2 (Normal)", test_num);
        input0 = 24'h0000EE;
        input1 = 24'h0000FF;
        input2 = 24'hABCDEF;
        select = 2'b10;

        #1;


        check_outputs(24'hABCDEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Global Error (Input 0 exceeds threshold)", test_num);

        input0 = 24'hFFFFFF;
        input1 = 24'h000100;
        input2 = 24'h000200;
        select = 2'b01;

        #1;


        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Global Error (Input 1 exceeds threshold)", test_num);
        input0 = 24'h000100;
        input1 = 24'hFFFFFF;
        input2 = 24'h000200;
        select = 2'b10;

        #1;


        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Global Error (Input 2 exceeds threshold)", test_num);
        input0 = 24'h000100;
        input1 = 24'h000200;
        input2 = 24'hFFFFFF;
        select = 2'b00;

        #1;


        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs zero", test_num);
        input0 = 24'h000000;
        input1 = 24'h000000;
        input2 = 24'h000000;
        select = 2'b00;

        #1;


        check_outputs(24'h000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary values (High but safe)", test_num);

        input0 = 24'h800000;
        input1 = 24'hFFFFFE;
        input2 = 24'h7FFFFF;
        select = 2'b01;

        #1;


        check_outputs(24'hFFFFFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_24bit_mux Testbench");
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
        input [23:0] expected_output_value;
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
