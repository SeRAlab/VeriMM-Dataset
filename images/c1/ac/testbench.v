`timescale 1ns/1ps

module AddRoundKey_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg data_valid_in;
    reg key_valid_in;
    reg reset;
    reg [127:0] round_key;
    wire [127:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AddRoundKey dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid_in(data_valid_in),
        .key_valid_in(key_valid_in),
        .reset(reset),
        .round_key(round_key),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            data_in = 128'b0;
            round_key = 128'b0;
            data_valid_in = 0;
            key_valid_in = 0;
            #15;
            reset = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            reset_dut();
            data_in = 128'h0;
            round_key = 128'h0;
            data_valid_in = 1;
            key_valid_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones XOR All Zeros", test_num);
            reset_dut();
            data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            round_key = 128'h00000000000000000000000000000000;
            data_valid_in = 1;
            key_valid_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Self XOR (Data == Key)", test_num);
            reset_dut();
            data_in = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            round_key = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            data_valid_in = 1;
            key_valid_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial Validity (Only Data Valid)", test_num);
            reset_dut();
            data_in = 128'h123456789ABCDEF0123456789ABCDEF0;
            round_key = 128'hFEDCBA9876543210FEDCBA9876543210;
            data_valid_in = 1;
            key_valid_in = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial Validity (Only Key Valid)", test_num);
            reset_dut();
            data_in = 128'h123456789ABCDEF0123456789ABCDEF0;
            round_key = 128'hFEDCBA9876543210FEDCBA9876543210;
            data_valid_in = 0;
            key_valid_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(data_out, 1'b0);
        end
        endtask

    task testcase006;

        reg [127:0] expected;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern XOR", test_num);
            reset_dut();
            data_in   = 128'hCAFEBABEDEADBEEFCAFEBABEDEADBEEF;
            round_key = 128'h0123456789ABCDEF0123456789ABCDEF;
            expected  = 128'hCAFEBABEDEADBEEFCAFEBABEDEADBEEF ^ 128'h0123456789ABCDEF0123456789ABCDEF;
            data_valid_in = 1;
            key_valid_in = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(expected, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Async Reset Check", test_num);
            reset_dut();
            data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            round_key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            data_valid_in = 1;
            key_valid_in = 1;
            @(posedge clk);
            #2;

            if (valid_out === 1'b1) begin

                reset = 0;
                #1;
                #1;

                check_outputs(128'h0, 1'b0);
                reset = 1;
            end else begin
                $display("FAIL: Initial setup for reset test failed");
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
        $display("AddRoundKey Testbench");
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
        input [127:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, data_valid_in, key_valid_in, reset, round_key, data_out, valid_out);
    end

endmodule
