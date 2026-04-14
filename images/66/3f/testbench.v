`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [1:0] select;
    wire [3:0] data_out;

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
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select data0 (4'hA)");
            data0 = 4'hA;
            data1 = 4'h5;
            data2 = 4'h0;
            data3 = 4'hF;
            select = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select data1 (4'h5)");
            data0 = 4'hA;
            data1 = 4'h5;
            data2 = 4'h0;
            data3 = 4'hF;
            select = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Select data2 (4'h0)");
            data0 = 4'hA;
            data1 = 4'h5;
            data2 = 4'h0;
            data3 = 4'hF;
            select = 2'b10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Select data3 (4'hF)");
            data0 = 4'hA;
            data1 = 4'h5;
            data2 = 4'h0;
            data3 = 4'hF;
            select = 2'b11;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: All inputs same (4'h7)");
            data0 = 4'h7;
            data1 = 4'h7;
            data2 = 4'h7;
            data3 = 4'h7;
            select = 2'b10;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Boundary values (All zeros)");
            data0 = 4'h0;
            data1 = 4'h0;
            data2 = 4'h0;
            data3 = 4'h0;
            select = 2'b01;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Boundary values (All ones)");
            data0 = 4'hF;
            data1 = 4'hF;
            data2 = 4'hF;
            data3 = 4'hF;
            select = 2'b11;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Alternating bits pattern");
            data0 = 4'h5;
            data1 = 4'hA;
            data2 = 4'hC;
            data3 = 4'h3;
            select = 2'b10;
            #1;

            check_outputs(4'hC);
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
