`timescale 1ns/1ps

module sha256_simple_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire [255:0] hash;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_simple dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .start(start),
        .hash(hash),
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
            start = 0;
            message = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_for_ready;

        integer timeout;
        begin
            timeout = 0;
            while (!ready && timeout < 1000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
            if (timeout >= 1000) begin
                $display("ERROR: Timeout waiting for ready signal");
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Message", test_num);
            reset_dut();

            message = 512'h0;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait_for_ready();



            #1;




            check_outputs(256'hE3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Message", test_num);
            reset_dut();

            message = {16{32'hFFFFFFFF}};
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait_for_ready();


            #1;



            check_outputs(256'hCF5B16A778AF833DABB58E717A0D951113E4B3F50047D4C8681E37A66723B2EF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            message = {32{16'hAAAA}};
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait_for_ready();


            #1;



            check_outputs(256'h5D1367067980302E31D61510B07545E0B497B0014D8A29A098E010672151752E, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        reg [511:0] msg_temp;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental Byte Pattern", test_num);
            reset_dut();

            for (i = 0; i < 64; i = i + 1) begin
                msg_temp[i*8 +: 8] = i[7:0];
            end

            message = msg_temp;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            wait_for_ready();


            #1;



            check_outputs(256'h4F33333333333333333333333333333333333333333333333333333333333333, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pulse Start after Reset", test_num);
            reset_dut();


            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_ready();


            #1;



            check_outputs(256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_simple Testbench");
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
        input [255:0] expected_hash;
        input expected_ready;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: hash=%h, ready=%b",
                         hash, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h, ready=%b",
                         expected_hash, expected_ready);
                $display("  Got:      hash=%h, ready=%b",
                         hash, ready);
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
        $dumpvars(0,clk, message, rst, start, hash, ready);
    end

endmodule
