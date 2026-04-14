`timescale 1ns/1ps

module mux_2_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data0;
    reg [15:0] data1;
    reg sel;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2_to_1 dut (
        .data0(data0),
        .data1(data1),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data0 = 16'h0000;
            data1 = 16'hFFFF;
            sel = 1'b0;
            $display("Test %0d: Select data0 (0000), data1 is FFFF", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data0 = 16'h0000;
            data1 = 16'hFFFF;
            sel = 1'b1;
            $display("Test %0d: Select data1 (FFFF), data0 is 0000", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data0 = 16'hAAAA;
            data1 = 16'h5555;
            sel = 1'b0;
            $display("Test %0d: Select data0 (AAAA), data1 is 5555", test_num);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data0 = 16'hAAAA;
            data1 = 16'h5555;
            sel = 1'b1;
            $display("Test %0d: Select data1 (5555), data0 is AAAA", test_num);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data0 = 16'h1234;
            data1 = 16'hEDCB;
            sel = 1'b0;
            $display("Test %0d: Select data0 (1234), data1 is EDCB", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data0 = 16'h1234;
            data1 = 16'hEDCB;
            sel = 1'b1;
            $display("Test %0d: Select data1 (EDCB), data0 is 1234", test_num);
            #1;

            check_outputs(16'hEDCB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data0 = 16'hFFFF;
            data1 = 16'h0000;
            sel = 1'b0;
            $display("Test %0d: Select data0 (FFFF) boundary check", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data0 = 16'hFFFF;
            data1 = 16'h0000;
            sel = 1'b1;
            $display("Test %0d: Select data1 (0000) boundary check", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2_to_1 Testbench");
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
        input [15:0] expected_data_out;
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
