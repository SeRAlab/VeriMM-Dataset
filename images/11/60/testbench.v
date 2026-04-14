`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] enable;
    reg [3:0] request;
    reg reset;
    wire [1:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .enable(enable),
        .request(request),
        .reset(reset),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 4'b0000;
            request = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            enable = 4'b1111;
            request = 4'b0001;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable = 4'b1111;
            request = 4'b0100;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 4'b1111;
            request = 4'b1011;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 4'b0111;
            request = 4'b1010;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable = 4'b1111;
            request = 4'b0110;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            enable = 4'b1111;
            request = 4'b1111;
            reset = 1;
            #2;


            #1;



            check_outputs(2'd0);
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
        input [1:0] expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%h",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h",
                         expected_grant);
                $display("  Got:      grant=%h",
                         grant);
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
        $dumpvars(0,clk, enable, request, reset, grant);
    end

endmodule
