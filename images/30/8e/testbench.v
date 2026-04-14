`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req1;
    reg req2;
    reg rst;
    wire [1:0] active_channel;
    wire grant1;
    wire grant2;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req1(req1),
        .req2(req2),
        .rst(rst),
        .active_channel(active_channel),
        .grant1(grant1),
        .grant2(grant2),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req1 = 0;
            req2 = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 1 Single Request", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;



            wait(grant1 == 1);
            wait(transfer_complete == 1);



            #1;




            check_outputs(2'b01, 1'b1, 1'b0, 1'b1);

            @(posedge clk);
            req1 = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Channel 2 Single Request", test_num);
            reset_dut();

            @(posedge clk);
            req2 = 1;

            wait(grant2 == 1);
            wait(transfer_complete == 1);



            #1;




            check_outputs(2'b10, 1'b0, 1'b1, 1'b1);

            @(posedge clk);
            req2 = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Requests (Ch1 Priority)", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;
            req2 = 1;


            wait(grant1 == 1);


            #1;



            check_outputs(2'b01, 1'b1, 1'b0, 0);



            @(posedge clk);
            req1 = 0;
            req2 = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Channel Requests", test_num);
            reset_dut();


            @(posedge clk);
            req1 = 1;
            wait(transfer_complete == 1);
            @(posedge clk);
            req1 = 0;


            @(posedge clk);
            req2 = 1;
            wait(grant2 == 1);
            wait(transfer_complete == 1);


            #1;



            check_outputs(2'b10, 1'b0, 1'b1, 1'b1);

            @(posedge clk);
            req2 = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset During Active Transfer", test_num);
            reset_dut();

            @(posedge clk);
            req1 = 1;
            wait(grant1 == 1);


            #15;
            rst = 1;
            #20;
            rst = 0;
            #10;


            #1;



            check_outputs(2'b00, 1'b0, 1'b0, 1'b0);
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
        testcase006();
        
        
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
        input [1:0] expected_active_channel;
        input expected_grant1;
        input expected_grant2;
        input expected_transfer_complete;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_grant1 === (expected_grant1 ^ grant1 ^ expected_grant1) &&
                expected_grant2 === (expected_grant2 ^ grant2 ^ expected_grant2) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, grant1=%b, grant2=%b, transfer_complete=%b",
                         active_channel, grant1, grant2, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, grant1=%b, grant2=%b, transfer_complete=%b",
                         expected_active_channel, expected_grant1, expected_grant2, expected_transfer_complete);
                $display("  Got:      active_channel=%h, grant1=%b, grant2=%b, transfer_complete=%b",
                         active_channel, grant1, grant2, transfer_complete);
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
        $dumpvars(0,clk, req1, req2, rst, active_channel, grant1, grant2, transfer_complete);
    end

endmodule
