`timescale 1ns/1ps

module simplified_md5_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simplified_md5 dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .hash(hash)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            message = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros Input", test_num);
            reset_dut();
            message = 512'h0;


            #1;



            check_outputs(128'h702334f686c478a0d78314170868f081);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones Input", test_num);
            reset_dut();
            message = {16{32'hFFFFFFFF}};
            #1;

            check_outputs(128'h366050e64152777651a510526e0e9323);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bit Pattern (0x55...)", test_num);
            reset_dut();
            message = {64{8'h55}};
            #1;

            check_outputs(128'h4e6f47702f309995c52c033890326444);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Alternating Bit Pattern (0xAA...)", test_num);
            reset_dut();
            message = {64{8'hAA}};
            #1;

            check_outputs(128'h9f9c94326f584e0321523455a1098273);
        end
        endtask

    task testcase005;

        reg [511:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Incremental Byte Pattern", test_num);
            reset_dut();
            for (i = 0; i < 64; i = i + 1) begin
                pattern[i*8 +: 8] = i[7:0];
            end
            message = pattern;
            #1;

            check_outputs(128'haabbccddeeff00112233445566778899);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Walking Bit Pattern", test_num);
            reset_dut();
            message = 512'h1;
            #1;

            check_outputs(128'h1234567890abcdef1234567890abcdef);
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
        input [127:0] expected_hash;
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
        $dumpvars(0,clk, message, rst, hash);
    end

endmodule
