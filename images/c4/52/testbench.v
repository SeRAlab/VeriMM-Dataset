`timescale 1ns/1ps

module mux4_1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] select;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4_1 dut (
        .data_in(data_in),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select Input 0, Data 0001 (Expect 1)", test_num);
            data_in = 4'b0001;
            select = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select Input 0, Data 1110 (Expect 0)", test_num);
            data_in = 4'b1110;
            select = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select Input 1, Data 0010 (Expect 1)", test_num);
            data_in = 4'b0010;
            select = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select Input 1, Data 1101 (Expect 0)", test_num);
            data_in = 4'b1101;
            select = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select Input 2, Data 0100 (Expect 1)", test_num);
            data_in = 4'b0100;
            select = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select Input 2, Data 1011 (Expect 0)", test_num);
            data_in = 4'b1011;
            select = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select Input 3, Data 1000 (Expect 1)", test_num);
            data_in = 4'b1000;
            select = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Select Input 3, Data 0111 (Expect 0)", test_num);
            data_in = 4'b0111;
            select = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: All Inputs High, Select 01 (Expect 1)", test_num);
            data_in = 4'b1111;
            select = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: All Inputs Low, Select 11 (Expect 0)", test_num);
            data_in = 4'b0000;
            select = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4_1 Testbench");
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
        input expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b",
                         expected_data_out);
                $display("  Got:      data_out=%b",
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
