`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg acknowledge1;
    reg acknowledge2;
    reg clk;
    reg request1;
    reg request2;
    wire active_channel;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .acknowledge1(acknowledge1),
        .acknowledge2(acknowledge2),
        .clk(clk),
        .request1(request1),
        .request2(request2),
        .active_channel(active_channel),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            request1 = 0;
            request2 = 0;
            acknowledge1 = 0;
            acknowledge2 = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            request1 = 1;
            @(posedge clk);


            acknowledge1 = 1;
            @(posedge clk);


            #1;



            check_outputs(0, 1);

            request1 = 0;
            acknowledge1 = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            request2 = 1;
            @(posedge clk);


            acknowledge2 = 1;
            @(posedge clk);


            #1;



            check_outputs(1, 1);

            request2 = 0;
            acknowledge2 = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            request1 = 1;
            request2 = 1;
            @(posedge clk);


            acknowledge1 = 1;
            @(posedge clk);
            acknowledge1 = 0;
            request1 = 0;

            @(posedge clk);

            acknowledge2 = 1;
            @(posedge clk);


            #1;



            check_outputs(1, 1);

            request2 = 0;
            acknowledge2 = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            request1 = 1;
            @(posedge clk);
            acknowledge1 = 1;
            @(posedge clk);
            acknowledge1 = 0;
            request1 = 0;
            @(posedge clk);


            request1 = 1;
            request2 = 1;
            @(posedge clk);


            acknowledge2 = 1;
            @(posedge clk);

            #1;


            check_outputs(1, 1);

            request1 = 0;
            request2 = 0;
            acknowledge2 = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            request1 = 1;
            @(posedge clk);
            acknowledge1 = 1;
            @(posedge clk);
            request1 = 0;
            acknowledge1 = 0;
            @(posedge clk);


            request2 = 1;
            @(posedge clk);
            acknowledge2 = 1;
            @(posedge clk);

            #1;


            check_outputs(1, 1);

            request2 = 0;
            acknowledge2 = 0;
            repeat(2) @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_active_channel;
        input expected_transfer_complete;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%b, transfer_complete=%b",
                         active_channel, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%b, transfer_complete=%b",
                         expected_active_channel, expected_transfer_complete);
                $display("  Got:      active_channel=%b, transfer_complete=%b",
                         active_channel, transfer_complete);
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
        $dumpvars(0,acknowledge1, acknowledge2, clk, request1, request2, active_channel, transfer_complete);
    end

endmodule
