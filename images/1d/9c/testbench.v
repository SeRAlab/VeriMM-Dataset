`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_request;
    wire response;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .clk(clk),
        .new_request(new_request),
        .response(response)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            new_request = 0;
            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Single Request");
            reset_dut();

            @(posedge clk);
            new_request <= 1;
            @(posedge clk);
            new_request <= 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: No Request");
            reset_dut();

            @(posedge clk);
            new_request <= 0;
            @(posedge clk);


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Continuous Requests");
            reset_dut();

            @(posedge clk);
            new_request <= 1;
            @(posedge clk);
            new_request <= 1;
            @(posedge clk);
            new_request <= 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Delayed Request");
            reset_dut();

            repeat (5) @(posedge clk);

            @(posedge clk);
            new_request <= 1;
            @(posedge clk);
            new_request <= 0;

            @(posedge clk);
            #1;
            #1;

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
        input expected_response;
        begin
            if (expected_response === (expected_response ^ response ^ expected_response)) begin
                $display("PASS");
                $display("  Outputs: response=%b",
                         response);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: response=%b",
                         expected_response);
                $display("  Got:      response=%b",
                         response);
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
        $dumpvars(0,clk, new_request, response);
    end

endmodule
