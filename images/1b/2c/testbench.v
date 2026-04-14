`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data_in;
    reg end_of_data;
    wire [15:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data_in(data_in),
        .end_of_data(end_of_data),
        .checksum(checksum)
    );

    // Clock generation (10ns period)
    initial begin
        end_of_data = 0;
        forever #5 end_of_data = ~end_of_data;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            end_of_data = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task feed_word;

        input [15:0] word;
        begin
            data_in = word;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic sum (no carry)", test_num);
            reset_dut();
            feed_word(16'h1111);
            feed_word(16'h2222);
            end_of_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCCCC);
            end_of_data = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sum with carry-out", test_num);
            reset_dut();
            feed_word(16'hFFFF);
            feed_word(16'h0001);
            end_of_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFE);
            end_of_data = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-word sum with carries", test_num);
            reset_dut();
            feed_word(16'hAAAA);
            feed_word(16'hBBBB);
            feed_word(16'hCCCC);
            end_of_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCCCC);
            end_of_data = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero data", test_num);
            reset_dut();
            feed_word(16'h0000);
            feed_word(16'h0000);
            end_of_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
            end_of_data = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All 0xFFFF values", test_num);
            reset_dut();
            feed_word(16'hFFFF);
            feed_word(16'hFFFF);
            end_of_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
            end_of_data = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simplified IP Header segment", test_num);
            reset_dut();
            feed_word(16'h4500);
            feed_word(16'h003C);
            feed_word(16'h1C46);
            feed_word(16'h4000);
            feed_word(16'h4006);
            end_of_data = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1E77);
            end_of_data = 0;
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
        $dumpvars(0,data_in, end_of_data, checksum);
    end

endmodule
