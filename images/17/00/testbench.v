`timescale 1ns/1ps

module simplified_md5_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg reset;
    reg start;
    wire done;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simplified_md5 dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .done(done),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 64'h0000000000000000;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'hE2C05505E54D823908990F623F934220);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 64'hFFFFFFFFFFFFFFFF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 128'h948C9A690B4592231F740B0703C12111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 64'hAAAAAAAAAAAAAAAA;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h5D3E3F01C3A29B06456789ABCDEF0123);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 64'h0123456789ABCDEF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'hAABBCCDDEEFF00112233445566778899);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 64'h8000000000000000;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 128'h77889900112233445566AABBCCDDEEFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simplified_md5 Testbench");
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
        input [127:0] expected_hash_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hash_out=%h",
                         done, hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hash_out=%h",
                         expected_done, expected_hash_out);
                $display("  Got:      done=%b, hash_out=%h",
                         done, hash_out);
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
        $dumpvars(0,clk, data_in, reset, start, done, hash_out);
    end

endmodule
