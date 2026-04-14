`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through (control = 0001)", test_num);

            control = 4'b0001;
            data_in = 32'hA5A5_1234;

            #1;


            check_outputs(32'hA5A5_1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Reversal (control = 0010)", test_num);

            control = 4'b0010;
            data_in = 32'h0000_0001;

            #1;


            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Reversal Complex (control = 0010)", test_num);

            control = 4'b0010;
            data_in = 32'hF000_0000;

            #1;


            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invert Bits (control = 0011)", test_num);

            control = 4'b0011;
            data_in = 32'hFFFF_0000;

            #1;


            check_outputs(32'h0000_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper 16 Bits (control = 0100)", test_num);

            control = 4'b0100;
            data_in = 32'hDEAD_BEEF;

            #1;


            check_outputs(32'h0000_DEAD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Default Case - Zero (control = 0000)", test_num);

            control = 4'b0000;
            data_in = 32'hFFFF_FFFF;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Default Case - Invalid (control = 1111)", test_num);

            control = 4'b1111;
            data_in = 32'h1234_5678;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [31:0] expected_data_out;
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
