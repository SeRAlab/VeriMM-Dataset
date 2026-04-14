`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] request;
    reg reset;
    wire ack;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request(request),
        .reset(reset),
        .ack(ack),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            request = 4'b0000;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single request on Channel 0", test_num);
            reset_dut();

            request = 4'b0001;

            wait(ack == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single request on Channel 3", test_num);
            reset_dut();

            request = 4'b1000;
            wait(ack == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (CH1 and CH2), Priority test", test_num);
            reset_dut();

            request = 4'b0110;
            wait(ack == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle state (No requests)", test_num);
            reset_dut();

            request = 4'b0000;
            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during request", test_num);
            reset_dut();

            request = 4'b0100;
            repeat (1) @(posedge clk);
            reset = 1;
            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b0, 4'b0000);
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
        input expected_ack;
        input [3:0] expected_grant;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, grant=%h",
                         ack, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, grant=%h",
                         expected_ack, expected_grant);
                $display("  Got:      ack=%b, grant=%h",
                         ack, grant);
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
        $dumpvars(0,clk, request, reset, ack, grant);
    end

endmodule
