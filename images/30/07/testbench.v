`timescale 1ns/1ps

module mux32to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg [4:0] select;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux32to1 dut (
        .data_in(data_in),
        .select(select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data_in = 32'h00000001;
            select = 5'd0;
            $display("Test %0d: Select index 0, Data[0]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data_in = 32'h80000000;
            select = 5'd31;
            $display("Test %0d: Select index 31, Data[31]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data_in = 32'hFFFF7FFF;
            select = 5'd15;
            $display("Test %0d: Select index 15, Data[15]=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data_in = 32'h00000000;
            select = 5'd7;
            $display("Test %0d: Select index 7, All Data=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data_in = 32'hFFFFFFFF;
            select = 5'd22;
            $display("Test %0d: Select index 22, All Data=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data_in = (1 << 10);
            select = 5'd10;
            $display("Test %0d: Select index 10, Data[10]=1 (Walking 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data_in = 32'hAAAA_AAAA;
            select = 5'd1;
            $display("Test %0d: Select index 1, Data=0xAAAAAAAA", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux32to1 Testbench");
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
