`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error_signal;
    reg reset;
    reg start_read;
    reg start_write;
    wire [1:0] current_state;
    wire read_complete;
    wire write_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .error_signal(error_signal),
        .reset(reset),
        .start_read(start_read),
        .start_write(start_write),
        .current_state(current_state),
        .read_complete(read_complete),
        .write_complete(write_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_read = 0;
            start_write = 0;
            error_signal = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial IDLE state", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition IDLE -> READ", test_num);
            reset_dut();
            start_read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition IDLE -> WRITE", test_num);
            reset_dut();
            start_write = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transition IDLE -> ERROR", test_num);
            reset_dut();
            error_signal = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Transition READ -> ERROR", test_num);
            reset_dut();
            start_read = 1;
            @(posedge clk);
            #1;
            error_signal = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Transition WRITE -> ERROR", test_num);
            reset_dut();
            start_write = 1;
            @(posedge clk);
            #1;
            error_signal = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: READ Completion to IDLE", test_num);
            reset_dut();
            start_read = 1;
            @(posedge clk);
            #1;
            start_read = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: WRITE Completion to IDLE", test_num);
            reset_dut();
            start_write = 1;
            @(posedge clk);
            #1;
            start_write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Recovery from ERROR via Reset", test_num);
            reset_dut();
            error_signal = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            error_signal = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        input [1:0] expected_current_state;
        input expected_read_complete;
        input expected_write_complete;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_read_complete === (expected_read_complete ^ read_complete ^ expected_read_complete) &&
                expected_write_complete === (expected_write_complete ^ write_complete ^ expected_write_complete)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, read_complete=%b, write_complete=%b",
                         current_state, read_complete, write_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, read_complete=%b, write_complete=%b",
                         expected_current_state, expected_read_complete, expected_write_complete);
                $display("  Got:      current_state=%h, read_complete=%b, write_complete=%b",
                         current_state, read_complete, write_complete);
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
        $dumpvars(0,clk, error_signal, reset, start_read, start_write, current_state, read_complete, write_complete);
    end

endmodule
