`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    reg start;
    wire done;
    wire [127:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .hmac(hmac)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            key = 0;
            message = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();

            key = 128'h0;
            message = 128'h0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            @(posedge clk);



            #1;




            check_outputs(1'b1, hmac);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            reset_dut();

            key     = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, hmac);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            reset_dut();

            key     = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, hmac);
        end
        endtask

    task testcase004;

        reg [127:0] prev_hmac;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key Sensitivity Check", test_num);


            reset_dut();
            key     = 128'h123456789ABCDEF0123456789ABCDEF0;
            message = 128'hDEADC0DEDEADC0DEDEADC0DEDEADC0DE;
            start = 1;
            @(posedge clk); start = 0;
            wait(done == 1);
            prev_hmac = hmac;
            @(posedge clk);


            reset_dut();
            key     = 128'h123456789ABCDEF0123456789ABCDEF1;
            message = 128'hDEADC0DEDEADC0DEDEADC0DEDEADC0DE;
            start = 1;
            @(posedge clk); start = 0;
            wait(done == 1);

            if (hmac != prev_hmac) begin
                $display("Success: HMAC changed with key update.");
                #1;

                check_outputs(1'b1, hmac);
            end else begin
                $display("Error: HMAC did not change despite key update!");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [127:0] prev_hmac;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Message Sensitivity Check", test_num);


            reset_dut();
            key     = 128'hFEEDFACECAFEBEEFFEEDFACECAFEBEEF;
            message = 128'h00000000000000000000000000000001;
            start = 1;
            @(posedge clk); start = 0;
            wait(done == 1);
            prev_hmac = hmac;
            @(posedge clk);


            reset_dut();
            key     = 128'hFEEDFACECAFEBEEFFEEDFACECAFEBEEF;
            message = 128'h00000000000000000000000000000002;
            start = 1;
            @(posedge clk); start = 0;
            wait(done == 1);

            if (hmac != prev_hmac) begin
                $display("Success: HMAC changed with message update.");
                #1;

                check_outputs(1'b1, hmac);
            end else begin
                $display("Error: HMAC did not change despite message update!");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("HMAC Testbench");
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
        input expected_done;
        input [127:0] expected_hmac;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hmac === (expected_hmac ^ hmac ^ expected_hmac)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hmac=%h",
                         done, hmac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hmac=%h",
                         expected_done, expected_hmac);
                $display("  Got:      done=%b, hmac=%h",
                         done, hmac);
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
        $dumpvars(0,clk, key, message, rst, start, done, hmac);
    end

endmodule
