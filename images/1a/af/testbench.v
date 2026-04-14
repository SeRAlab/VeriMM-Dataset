`timescale 1ns/1ps

module mac_address_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [47:0] mac_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mac_address_generator dut (
        .clk(clk),
        .reset(reset),
        .mac_address(mac_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
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
            $display("\nTest Case %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(48'h000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Single Increment", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'h000000000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify 10 Increments", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(48'h00000000000A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify 256 Increments (Byte Boundary)", test_num);
            reset_dut();
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(48'h000000000100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify 4096 Increments", test_num);
            reset_dut();
            repeat(4096) @(posedge clk);
            #1;
            #1;

            check_outputs(48'h000000001000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Reset during operation", test_num);
            reset_dut();
            repeat(50) @(posedge clk);

            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mac_address_generator Testbench");
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
        input [47:0] expected_mac_address;
        begin
            if (expected_mac_address === (expected_mac_address ^ mac_address ^ expected_mac_address)) begin
                $display("PASS");
                $display("  Outputs: mac_address=%h",
                         mac_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mac_address=%h",
                         expected_mac_address);
                $display("  Got:      mac_address=%h",
                         mac_address);
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
        $dumpvars(0,clk, reset, mac_address);
    end

endmodule
