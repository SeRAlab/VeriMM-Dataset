`timescale 1ns/1ps

module pcie_request_handler_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg request;
    reg request_type;
    reg reset;
    wire ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_request_handler dut (
        .clk(clk),
        .request(request),
        .request_type(request_type),
        .reset(reset),
        .ack(ack)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Valid Read Request", test_num);

        reset = 1; request = 0; request_type = 0;
        @(posedge clk);
        #2 reset = 0;


        @(negedge clk);
        request = 1;
        request_type = 0;


        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Valid Write Request", test_num);

        reset = 1; request = 0; request_type = 0;
        @(posedge clk);
        #2 reset = 0;


        @(negedge clk);
        request = 1;
        request_type = 1;

        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: No Request Active", test_num);

        reset = 1; request = 0; request_type = 0;
        @(posedge clk);
        #2 reset = 0;


        @(negedge clk);
        request = 0;
        request_type = 1;

        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Request during Reset", test_num);

        reset = 1;
        request = 1;
        request_type = 0;

        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_request_handler Testbench");
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
        input expected_ack;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ack === (expected_ack ^ ack ^ expected_ack)) begin
                $display("PASS");
                $display("  Outputs: ack=%b",
                         ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b",
                         expected_ack);
                $display("  Got:      ack=%b",
                         ack);
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

endmodule
