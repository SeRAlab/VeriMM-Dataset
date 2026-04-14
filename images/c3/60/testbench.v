`timescale 1ns/1ps

module four_input_mux_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in_0;
    reg [3:0] data_in_1;
    reg [3:0] data_in_2;
    reg [3:0] data_in_3;
    reg [1:0] select;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_input_mux dut (
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Selecting data_in_0 (select = 00)", test_num);
            data_in_0 = 4'hA;
            data_in_1 = 4'h5;
            data_in_2 = 4'h3;
            data_in_3 = 4'hF;
            select = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Selecting data_in_1 (select = 01)", test_num);
            data_in_0 = 4'hA;
            data_in_1 = 4'h5;
            data_in_2 = 4'h3;
            data_in_3 = 4'hF;
            select = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Selecting data_in_2 (select = 10)", test_num);
            data_in_0 = 4'hA;
            data_in_1 = 4'h5;
            data_in_2 = 4'h3;
            data_in_3 = 4'hF;
            select = 2'b10;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Selecting data_in_3 (select = 11)", test_num);
            data_in_0 = 4'hA;
            data_in_1 = 4'h5;
            data_in_2 = 4'h3;
            data_in_3 = 4'hF;
            select = 2'b11;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary Value Check (All zeros)", test_num);
            data_in_0 = 4'h0;
            data_in_1 = 4'h0;
            data_in_2 = 4'h0;
            data_in_3 = 4'h0;
            select = 2'b10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Switching select with fixed inputs", test_num);
            data_in_0 = 4'h1;
            data_in_1 = 4'h2;
            data_in_2 = 4'h4;
            data_in_3 = 4'h8;

            select = 2'b00; #1;
            select = 2'b01; #1;
            select = 2'b11;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Boundary Value Check (All ones)", test_num);
            data_in_0 = 4'hF;
            data_in_1 = 4'hF;
            data_in_2 = 4'hF;
            data_in_3 = 4'hF;
            select = 2'b01;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_input_mux Testbench");
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
