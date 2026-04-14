`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg [15:0] data2;
    reg [15:0] data3;
    reg [1:0] select;
    wire [15:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .select(select),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data0", test_num);
            data0 = 16'hAAAA;
            data1 = 16'h0000;
            data2 = 16'h0000;
            data3 = 16'h0000;
            select = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data1", test_num);
            data0 = 16'h1111;
            data1 = 16'hBBBB;
            data2 = 16'h2222;
            data3 = 16'h3333;
            select = 2'b01;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data2", test_num);
            data0 = 16'h0001;
            data1 = 16'h0002;
            data2 = 16'hCCCC;
            data3 = 16'h0003;
            select = 2'b10;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data3", test_num);
            data0 = 16'hF0F0;
            data1 = 16'h0F0F;
            data2 = 16'hFFFF;
            data3 = 16'hDDDD;
            select = 2'b11;
            #1;

            check_outputs(16'hDDDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            data0 = 16'h0000;
            data1 = 16'h0000;
            data2 = 16'h0000;
            data3 = 16'h0000;
            select = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select data0 with FFFF", test_num);
            data0 = 16'hFFFF;
            data1 = 16'hAAAA;
            data2 = 16'h5555;
            data3 = 16'h1234;
            select = 2'b00;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selection switch test", test_num);
            data0 = 16'h1; data1 = 16'h2; data2 = 16'h3; data3 = 16'h4;
            select = 2'b01;
            #5;
            select = 2'b11;
            #1;

            check_outputs(16'h0004);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
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
        input [15:0] expected_output_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
