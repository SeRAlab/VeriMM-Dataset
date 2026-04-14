`timescale 1ns/1ps

module checksum_tb;

    // Testbench signals (sequential circuit)
    reg checksum_in;
    reg control;
    reg [7:0] data;
    reg reset;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum dut (
        .checksum_in(checksum_in),
        .control(control),
        .data(data),
        .reset(reset),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        control = 0;
        forever #5 control = ~control;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 8'b00000000;
            checksum_in = 1'b0;
            #20;
            $display("Test %0d: Data=0x00, Checksum_in=0", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 8'b00000001;
            checksum_in = 1'b0;
            #20;
            $display("Test %0d: Data=0x01, Checksum_in=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 8'b11111111;
            checksum_in = 1'b0;
            #20;
            $display("Test %0d: Data=0xFF, Checksum_in=0", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 8'h07;
            checksum_in = 1'b1;
            #20;
            $display("Test %0d: Data=0x07, Checksum_in=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 8'hAA;
            checksum_in = 1'b1;
            #20;
            $display("Test %0d: Data=0xAA, Checksum_in=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 8'h7F;
            checksum_in = 1'b1;
            #20;
            $display("Test %0d: Data=0x7F, Checksum_in=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data = 8'h55;
            checksum_in = 1'b0;
            #20;
            $display("Test %0d: Data=0x55, Checksum_in=0", test_num);
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
        $display("checksum Testbench");
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
        input expected_valid;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: valid=%b",
                         valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b",
                         expected_valid);
                $display("  Got:      valid=%b",
                         valid);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,checksum_in, control, data, reset, valid);
    end

endmodule
