`timescale 1ns/1ps

module checksum_checker_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_checker dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            data_in = 8'b0;
            checksum_in = 3'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test %0d: All zeros data (Sum=0), Checksum=0", test_num);
            data_in = 8'b00000000;
            checksum_in = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Test %0d: All zeros data (Sum=0), Checksum=1", test_num);
            data_in = 8'b00000000;
            checksum_in = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Test %0d: Data 10101010 (Sum=4), Checksum=4", test_num);
            data_in = 8'b10101010;
            checksum_in = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Test %0d: Data 11110000 (Sum=4), Checksum=2", test_num);
            data_in = 8'b11110000;
            checksum_in = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Test %0d: Data 01111111 (Sum=7), Checksum=7", test_num);
            data_in = 8'b01111111;
            checksum_in = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Test %0d: Data 11111111 (Sum=8), Checksum=0", test_num);
            data_in = 8'b11111111;
            checksum_in = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Test %0d: Data 00000001 (Sum=1), Checksum=1", test_num);
            data_in = 8'b00000001;
            checksum_in = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Test %0d: Data 00000000 (Sum=0), Checksum=7", test_num);
            data_in = 8'b00000000;
            checksum_in = 3'd7;
            @(posedge clk);
            #1;
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
        $display("checksum_checker Testbench");
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
        $dumpvars(0,checksum_in, clk, data_in, valid);
    end

endmodule
