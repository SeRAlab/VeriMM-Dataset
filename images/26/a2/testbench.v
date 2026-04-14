`timescale 1ns/1ps

module simple_des_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg [63:0] key;
    reg reset;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_des dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 64'h0;
            key = 64'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: All Zeros", test_num);
            reset_dut();
            data_in = 64'h0;
            key = 64'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Key is Zero", test_num);
            reset_dut();
            data_in = 64'hDEADBEEFCAFEBABE;
            key = 64'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hDEADBEEFCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Bit Inversion (Key all Fs)", test_num);
            reset_dut();
            data_in = 64'hAAAAAAAAAAAAAAAA;
            key = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h5555555555555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Same Data and Key (Expect 0)", test_num);
            reset_dut();
            data_in = 64'h1234567890ABCDEF;
            key = 64'h1234567890ABCDEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Mixed Bit Patterns", test_num);
            reset_dut();
            data_in = 64'hF0F0F0F0F0F0F0F0;
            key = 64'h0F0F0F0F0F0F0F0F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Standard XOR Logic Check", test_num);
            reset_dut();
            data_in = 64'h123456789ABCDEF0;
            key = 64'hFEDCBA9876543210;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'hECEAAC20ECEAACF0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_des Testbench");
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
        input [63:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, key, reset, data_out);
    end

endmodule
