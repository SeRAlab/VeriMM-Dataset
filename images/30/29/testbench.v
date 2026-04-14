`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] data_in;
    reg reset;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
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
            data_in = 64'h0;
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
            $display("\nTest Case %0d: Reset and Zero Input", test_num);
            reset_dut();

            data_in = 64'h0000000000000000;

            @(posedge clk);
            #2;


            #1;



            check_outputs(128'hD41D8CD98F00B204E9800998ECF8427E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input", test_num);
            reset_dut();

            data_in = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;


            #1;



            check_outputs(128'hE2FC714C4727EE9395F324CD2E7F331F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (AAAA)", test_num);
            reset_dut();

            data_in = 64'hAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h26344A3A26D6864C8A66D94F867C0E4B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (5555)", test_num);
            reset_dut();

            data_in = 64'h5555555555555555;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h779774656F64696163206D6573736167);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Specific Data Pattern", test_num);
            reset_dut();

            data_in = 64'h123456789ABCDEFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h0123456789ABCDEFFEDCBA9876543210);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit High (MSB)", test_num);
            reset_dut();

            data_in = 64'h8000000000000000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(128'hB9D36A89A9B489A9B4A9B489A9B489A9);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Back-to-back Inputs", test_num);
            reset_dut();


            data_in = 64'hDEADC0DEBEEFCAFE;
            @(posedge clk);
            #2;


            data_in = 64'hCAFEBABE12345678;
            @(posedge clk);
            #2;


            #1;



            check_outputs(128'h4F524D4154494F4E2053454355524954);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [127:0] expected_hash_out;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h",
                         hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h",
                         expected_hash_out);
                $display("  Got:      hash_out=%h",
                         hash_out);
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
        $dumpvars(0,clk, data_in, reset, hash_out);
    end

endmodule
