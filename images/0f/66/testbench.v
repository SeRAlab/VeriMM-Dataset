`timescale 1ns/1ps

module hmac_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    reg valid;
    wire [127:0] hmac_out;
    wire ready;

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
        .hmac_out(hmac_out),
        .ready(ready)
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
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);

            key = 128'h0;
            message = 128'h0;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;


            while (!ready) @(posedge clk);


            #1;



            check_outputs(128'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);

            key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            message = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(128'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Key XOR Message (Alternating)", test_num);

            key = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            message = 128'h55555555555555555555555555555555;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Hex Pattern", test_num);

            key = 128'h123456789ABCDEF0123456789ABCDEF0;
            message = 128'hFEDCBA9876543210FEDCBA9876543210;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Identity - Key with Zero Message", test_num);

            key = 128'hDEADBEEFCAFEBABE1337C0D3BAADF00D;
            message = 128'h0;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            while (!ready) @(posedge clk);


            #1;



            check_outputs(128'hDEADBEEFCAFEBABE1337C0D3BAADF00D, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Bits", test_num);

            key = 128'h0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F;
            message = 128'hF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0;
            valid = 1;
            @(posedge clk);
            #1 valid = 0;

            while (!ready) @(posedge clk);

            #1;


            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 1'b1);
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
        input [127:0] expected_hmac_out;
        input expected_ready;
        begin
            if (expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hmac_out=%h, ready=%b",
                         hmac_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac_out=%h, ready=%b",
                         expected_hmac_out, expected_ready);
                $display("  Got:      hmac_out=%h, ready=%b",
                         hmac_out, ready);
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
        $dumpvars(0,clk, key, message, rst, valid, hmac_out, ready);
    end

endmodule
