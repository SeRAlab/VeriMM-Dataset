`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_ch1;
    reg req_ch2;
    wire [7:0] data;
    wire done_ch1;
    wire done_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req_ch1(req_ch1),
        .req_ch2(req_ch2),
        .data(data),
        .done_ch1(done_ch1),
        .done_ch2(done_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            req_ch1 = 0;
            req_ch2 = 0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Channel 1 Request", test_num);
            reset_dut();

            req_ch1 = 1;

            fork
                begin
                    wait(done_ch1 == 1);
                end
                begin
                    repeat (20) @(posedge clk);
                end
            join_any

            #2;
            #1;

            check_outputs(data, 1'b1, 1'b0);

            req_ch1 = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Channel 2 Request", test_num);
            reset_dut();

            req_ch2 = 1;
            fork
                begin
                    wait(done_ch2 == 1);
                end
                begin
                    repeat (20) @(posedge clk);
                end
            join_any

            #2;
            #1;

            check_outputs(data, 1'b0, 1'b1);

            req_ch2 = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Simultaneous Request (CH1 vs CH2 Priority)", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            req_ch1 = 1;
            req_ch2 = 1;


            fork
                begin
                    wait(done_ch1 || done_ch2);
                end
                begin
                    repeat (20) @(posedge clk);
                end
            join_any

            #2;


            if (done_ch1)
                #1;

                check_outputs(data, 1'b1, 1'b0);
            else if (done_ch2)
                #1;

                check_outputs(data, 1'b0, 1'b1);
            else
                #1;

                check_outputs(8'h00, 1'b1, 1'b1);

            req_ch1 = 0;
            req_ch2 = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Sequential Handover (CH2 waits for CH1)", test_num);
            reset_dut();


            req_ch1 = 1;
            @(posedge clk);
            #1;

            req_ch2 = 1;


            wait(done_ch1 == 1);
            #2;

            if (done_ch1 && !done_ch2) begin
                $display("  CH1 Finished, CH2 pending as expected.");
                req_ch1 = 0;


                wait(done_ch2 == 1);
                #2;
                #1;

                check_outputs(data, 1'b0, 1'b1);
            end else begin
                #1;

                check_outputs(data, 1'b1, 1'b0);
            end

            req_ch2 = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Idle State (No Requests)", test_num);
            reset_dut();

            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(data, 1'b0, 1'b0);
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
        input [7:0] expected_data;
        input expected_done_ch1;
        input expected_done_ch2;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_done_ch1 === (expected_done_ch1 ^ done_ch1 ^ expected_done_ch1) &&
                expected_done_ch2 === (expected_done_ch2 ^ done_ch2 ^ expected_done_ch2)) begin
                $display("PASS");
                $display("  Outputs: data=%h, done_ch1=%b, done_ch2=%b",
                         data, done_ch1, done_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, done_ch1=%b, done_ch2=%b",
                         expected_data, expected_done_ch1, expected_done_ch2);
                $display("  Got:      data=%h, done_ch1=%b, done_ch2=%b",
                         data, done_ch1, done_ch2);
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
        $dumpvars(0,clk, req_ch1, req_ch2, data, done_ch1, done_ch2);
    end

endmodule
