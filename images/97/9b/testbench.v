`timescale 1ns/1ps

module srl_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [4:0] shift_amount;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    srl_32bit dut (
        .A(A),
        .shift_amount(shift_amount),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 32'hFFFFFFFF;
            shift_amount = 5'd0;
            $display("Test %0d: Shift by 0 (Identity)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 32'h80000000;
            shift_amount = 5'd1;
            $display("Test %0d: Logical shift of MSB", test_num);
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 32'hFFFFFFFF;
            shift_amount = 5'd1;
            $display("Test %0d: Shift all ones by 1", test_num);
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 32'h12345678;
            shift_amount = 5'd4;
            $display("Test %0d: Shift by 4 (one hex digit)", test_num);
            #1;

            check_outputs(32'h01234567);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 32'h00000001;
            shift_amount = 5'd1;
            $display("Test %0d: Shift LSB out of bounds", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 32'hAAAAAAAA;
            shift_amount = 5'd31;
            $display("Test %0d: Shift by max amount (31)", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 32'h12345678;
            shift_amount = 5'd16;
            $display("Test %0d: Shift by half word (16)", test_num);
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 32'h00000000;
            shift_amount = 5'd5;
            $display("Test %0d: Shift zero value", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 32'h80000001;
            shift_amount = 5'd31;
            $display("Test %0d: Shift MSB to LSB", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 32'hF0F0F0F0;
            shift_amount = 5'd8;
            $display("Test %0d: Shift alternating pattern", test_num);
            #1;

            check_outputs(32'h00F0F0F0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("srl_32bit Testbench");
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
