`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    reg valid;
    wire [127:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .valid(valid),
        .hmac_out(hmac_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            key = 0;
            message = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'h0;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(hmac_reference(128'h0, 128'h0));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            key = {128{1'b1}};
            message = {128{1'b1}};
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(hmac_reference({128{1'b1}}, {128{1'b1}}));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits", test_num);
            reset_dut();
            key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(hmac_reference(128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA, 128'h55555555555555555555555555555555));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specific Key, Zero Message", test_num);
            reset_dut();
            key = 128'hDEADBEEFCAFED00D1234567887654321;
            message = 128'h0;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(hmac_reference(128'hDEADBEEFCAFED00D1234567887654321, 128'h0));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Key, Specific Message", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'hFEEDBEEF000011112222333344445555;
            valid = 1;
            @(posedge clk);
            valid = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(hmac_reference(128'h0, 128'hFEEDBEEF000011112222333344445555));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac Testbench");
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
        input [127:0] expected_hmac_out;
        begin
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h",
                         hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h",
                         expected_hmac_out);
                $display("  Got:      hmac_out=%h",
                         hmac_out);
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
        $dumpvars(0,clk, key, message, rst, valid, hmac_out);
    end

endmodule
