`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] e;
    reg [63:0] n;
    reg [31:0] plaintext;
    reg rst;
    wire [63:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .e(e),
        .n(n),
        .plaintext(plaintext),
        .rst(rst),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            plaintext = 0;
            e = 0;
            n = 1;
            #20;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case %0d: M=5, e=3, n=13", test_num);
            plaintext = 32'd5;
            e = 8'd3;
            n = 64'd13;


            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd8, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case %0d: M=1234, e=1, n=5555", test_num);
            plaintext = 32'd1234;
            e = 8'd1;
            n = 64'd5555;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd1234, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case %0d: M=10, e=2, n=100", test_num);
            plaintext = 32'd10;
            e = 8'd2;
            n = 64'd100;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case %0d: M=2, e=8, n=255", test_num);
            plaintext = 32'd2;
            e = 8'd8;
            n = 64'd255;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case %0d: M=15, e=3, n=100", test_num);
            plaintext = 32'd15;
            e = 8'd3;
            n = 64'd100;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd75, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case %0d: M=0, e=5, n=64", test_num);
            plaintext = 32'd0;
            e = 8'd5;
            n = 64'd64;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test Case %0d: M=1, e=255, n=1000", test_num);
            plaintext = 32'd1;
            e = 8'd255;
            n = 64'd1000;

            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encrypt Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [63:0] expected_ciphertext;
        input expected_done;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, done=%b",
                         ciphertext, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, done=%b",
                         expected_ciphertext, expected_done);
                $display("  Got:      ciphertext=%h, done=%b",
                         ciphertext, done);
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
        $dumpvars(0,clk, e, n, plaintext, rst, ciphertext, done);
    end

endmodule
