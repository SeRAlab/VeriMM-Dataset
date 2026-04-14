`timescale 1ns/1ps

module Barrel_shifter_256_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] data_in;
    reg dir;
    reg [7:0] shift_amt;
    wire [255:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Barrel_shifter_256 dut (
        .data_in(data_in),
        .dir(dir),
        .shift_amt(shift_amt),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Shift Left by 0", test_num);
            data_in = 256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            dir = 1'b1;
            shift_amt = 8'd0;
            #1;

            check_outputs(data_in);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift Right by 0", test_num);
            data_in = 256'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;
            dir = 1'b0;
            shift_amt = 8'd0;
            #1;

            check_outputs(data_in);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift Left by 1", test_num);
            data_in = 256'h8000000000000000000000000000000000000000000000000000000000000001;
            dir = 1'b1;
            shift_amt = 8'd1;

            #1;


            check_outputs(256'h0000000000000000000000000000000000000000000000000000000000000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Shift Right by 1", test_num);
            data_in = 256'h8000000000000000000000000000000000000000000000000000000000000001;
            dir = 1'b0;
            shift_amt = 8'd1;

            #1;


            check_outputs(256'h4000000000000000000000000000000000000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Shift Left by 4", test_num);
            data_in = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            dir = 1'b1;
            shift_amt = 8'd4;
            #1;

            check_outputs(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Shift Right by 4", test_num);
            data_in = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            dir = 1'b0;
            shift_amt = 8'd4;
            #1;

            check_outputs(256'h0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Shift Left by 128", test_num);

            data_in = 256'h00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            dir = 1'b1;
            shift_amt = 8'd128;
            #1;

            check_outputs(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Shift Right by 128", test_num);

            data_in = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000;
            dir = 1'b0;
            shift_amt = 8'd128;
            #1;

            check_outputs(256'h00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Shift Left by 255", test_num);
            data_in = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            dir = 1'b1;
            shift_amt = 8'd255;

            #1;


            check_outputs(256'h8000000000000000000000000000000000000000000000000000000000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Shift Right by 255", test_num);
            data_in = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            dir = 1'b0;
            shift_amt = 8'd255;

            #1;


            check_outputs(256'h0000000000000000000000000000000000000000000000000000000000000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Barrel_shifter_256 Testbench");
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
        input [255:0] expected_data_out;
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
