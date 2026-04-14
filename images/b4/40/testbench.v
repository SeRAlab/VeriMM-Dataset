`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg en;
    reg reset;
    wire [4:0] queue;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .reset(reset),
        .queue(queue)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill with all 1s", test_num);
            reset_dut();
            en = 1;
            data_in = 1;
            repeat(5) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift sequence 10110", test_num);
            reset_dut();
            en = 1;

            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);

            #1;
            en = 0;
            #1;

            check_outputs(5'b10110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable signal toggle test", test_num);
            reset_dut();


            en = 1; data_in = 1; @(posedge clk);


            en = 0; data_in = 0; @(posedge clk);
            en = 0; data_in = 1; @(posedge clk);


            en = 1; data_in = 0; @(posedge clk);

            #1;
            en = 0;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 7 bits (overflow)", test_num);
            reset_dut();
            en = 1;


            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);

            #1;
            en = 0;
            #1;

            check_outputs(5'b00110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            en = 1;
            data_in = 1;
            repeat(3) @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            en = 0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_queue Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [4:0] expected_queue;
        begin
            if (expected_queue === (expected_queue ^ queue ^ expected_queue)) begin
                $display("PASS");
                $display("  Outputs: queue=%h",
                         queue);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: queue=%h",
                         expected_queue);
                $display("  Got:      queue=%h",
                         queue);
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
        $dumpvars(0,clk, data_in, en, reset, queue);
    end

endmodule
