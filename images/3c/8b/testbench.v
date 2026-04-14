`timescale 1ns/1ps

module sha256_step_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg reset;
    wire [255:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_step dut (
        .clk(clk),
        .message(message),
        .reset(reset),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            message = 512'b0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Message", test_num);
            reset_dut();
            message = 512'h0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(256'hda5698d270b130327726702444630b321a938f3661830606f33d45c61309f3e0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Message", test_num);
            reset_dut();
            message = {16{32'hFFFFFFFF}};
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h62f928929e46a798533b6680cd7a2f24a737885b5d847171e51381e4c7980336);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern A", test_num);
            reset_dut();
            message = {16{32'hAAAAAAAA}};
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h039230180436979e2c608053f3e2e0321288f6f5842858000450503e91143891);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern B", test_num);
            reset_dut();
            message = {16{32'h55555555}};
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h2434651336946654924683050323386762316496660144962222384313264903);
        end
        endtask

    task testcase005;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Byte Pattern", test_num);
            reset_dut();
            for (i = 0; i < 64; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end
            message = pattern;
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h8bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd196a09e66);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit High", test_num);
            reset_dut();
            message = 512'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(256'h783d9ab5be0cd196a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_step Testbench");
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
        input [255:0] expected_hash;
        begin
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
        $dumpvars(0,clk, message, reset, hash);
    end

endmodule
