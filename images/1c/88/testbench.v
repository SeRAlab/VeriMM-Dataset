`timescale 1ns/1ps

module SPI_Controller_tb;

    // Testbench signals (sequential circuit)
    reg CS;
    reg MOSI;
    reg SCK;
    wire MISO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SPI_Controller dut (
        .CS(CS),
        .MOSI(MOSI),
        .SCK(SCK),
        .MISO(MISO)
    );

    // Clock generation (10ns period)
    initial begin
        CS = 0;
        forever #5 CS = ~CS;
    end

        task reset_dut;

        begin
            CS = 1;
            SCK = 0;
            MOSI = 0;
            #20;
        end
        endtask
    task send_bit;

        input bit_val;
        begin
            MOSI = bit_val;
            #5;
            SCK = 1;
            #5;
            SCK = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Shift 1,0,0,0 -> Expect MISO=1", test_num);
            reset_dut();
            CS = 0;
            send_bit(1);
            send_bit(0);
            send_bit(0);
            send_bit(0);
            #1;

            check_outputs(1'b1);
            CS = 1;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Shift 0,1,1,1 -> Expect MISO=0", test_num);
            reset_dut();
            CS = 0;
            send_bit(0);
            send_bit(1);
            send_bit(1);
            send_bit(1);
            #1;

            check_outputs(1'b0);
            CS = 1;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Shift 1,1,1,1 -> Expect MISO=1", test_num);
            reset_dut();
            CS = 0;
            send_bit(1);
            send_bit(1);
            send_bit(1);
            send_bit(1);
            #1;

            check_outputs(1'b1);
            CS = 1;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Shift 0,0,1,0 -> Expect MISO=0", test_num);
            reset_dut();
            CS = 0;
            send_bit(0);
            send_bit(0);
            send_bit(1);
            send_bit(0);
            #1;

            check_outputs(1'b0);
            CS = 1;
            #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SPI_Controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_MISO;
        begin
            if (expected_MISO === (expected_MISO ^ MISO ^ expected_MISO)) begin
                $display("PASS");
                $display("  Outputs: MISO=%b",
                         MISO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MISO=%b",
                         expected_MISO);
                $display("  Got:      MISO=%b",
                         MISO);
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
        $dumpvars(0,CS, MOSI, SCK, MISO);
    end

endmodule
