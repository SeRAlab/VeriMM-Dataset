`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg valid;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .checksum(checksum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 16'h0;
            valid = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: All zeros input", test_num);
            data_in = 16'h0000;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Single word (0x1234)", test_num);
            data_in = 16'h1234;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hEDCB);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Two words, no carry (0x1111 + 0x2222)", test_num);
            data_in = 16'h1111;
            valid = 1;
            @(posedge clk);
            data_in = 16'h2222;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Wrap-around carry (0xFFFF + 0x0001)", test_num);
            data_in = 16'hFFFF;
            valid = 1;
            @(posedge clk);
            data_in = 16'h0001;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Multiple Max Values (0xFFFF + 0xFFFF)", test_num);
            data_in = 16'hFFFF;
            valid = 1;
            @(posedge clk);
            data_in = 16'hFFFF;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %03d: Sequence (0x4500, 0x003c, 0x0000, 0x0000)", test_num);
            data_in = 16'h4500;
            valid = 1;
            @(posedge clk);
            data_in = 16'h003c;
            valid = 1;
            @(posedge clk);
            data_in = 16'h0000;
            valid = 1;
            @(posedge clk);
            data_in = 16'h0000;
            valid = 1;
            @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(16'hBA63);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
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
        input [15:0] expected_checksum;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
        $dumpvars(0,clk, data_in, reset, valid, checksum);
    end

endmodule
