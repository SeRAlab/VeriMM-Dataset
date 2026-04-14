`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req;
    reg reset;
    wire rsp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .rsp(rsp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 0;
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Single Request", test_num);
            reset_dut();

            @(posedge clk);
            req = 1;
            @(posedge clk);
            req = 0;


            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Idle State Check", test_num);
            reset_dut();


            repeat(5) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Request during Reset", test_num);
            reset_dut();


            reset = 1;
            req = 1;
            repeat(3) @(posedge clk);


            #1 reset = 0;
            req = 0;
            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Back-to-Back Requests", test_num);
            reset_dut();


            @(posedge clk);
            req = 1;
            @(posedge clk);
            req = 0;


            @(posedge clk);
            req = 1;
            @(posedge clk);
            req = 0;


            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sustained Request Pulse", test_num);
            reset_dut();

            @(posedge clk);
            req = 1;
            repeat(3) @(posedge clk);
            req = 0;


            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        input expected_rsp;
        begin
            if (expected_rsp === (expected_rsp ^ rsp ^ expected_rsp)) begin
                $display("PASS");
                $display("  Outputs: rsp=%b",
                         rsp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rsp=%b",
                         expected_rsp);
                $display("  Got:      rsp=%b",
                         rsp);
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
        $dumpvars(0,clk, req, reset, rsp);
    end

endmodule
