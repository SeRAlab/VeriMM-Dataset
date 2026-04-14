`timescale 1ns/1ps

module sd_card_interface_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg complete;
    reg reset;
    reg start_read;
    reg start_write;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_interface dut (
        .clk(clk),
        .complete(complete),
        .reset(reset),
        .start_read(start_read),
        .start_write(start_write),
        .state(state)
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
            complete = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: IDLE to READ transition", test_num);
            reset_dut();

            start_read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: IDLE to WRITE transition", test_num);
            reset_dut();

            start_write = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check (Read over Write)", test_num);
            reset_dut();

            start_read = 1;
            start_write = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: READ to IDLE transition", test_num);
            reset_dut();


            start_read = 1;
            @(posedge clk);
            #1;


            start_read = 0;
            complete = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: WRITE to IDLE transition", test_num);
            reset_dut();


            start_write = 1;
            @(posedge clk);
            #1;


            start_write = 0;
            complete = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stay in IDLE (No control)", test_num);
            reset_dut();

            start_read = 0;
            start_write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stay in READ (complete=0)", test_num);
            reset_dut();


            start_read = 1;
            @(posedge clk);
            #1;


            start_read = 0;
            complete = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stay in WRITE (complete=0)", test_num);
            reset_dut();


            start_write = 1;
            @(posedge clk);
            #1;


            start_write = 0;
            complete = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_interface Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, complete, reset, start_read, start_write, state);
    end

endmodule
