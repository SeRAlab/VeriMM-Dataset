`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .clk(clk),
        .enable(enable),
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .translated_ip(translated_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            external_ip = 0;
            internal_ip = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Translation (Internal: 192.168.1.1 -> External: 1.1.1.1)", test_num);
            reset_dut();

            internal_ip = 32'hC0A80101;
            external_ip = 32'h01010101;
            enable = 1;

            @(posedge clk);
            #1;
            enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h01010101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stability Check (Mapping should not update when enable is low)", test_num);
            reset_dut();


            internal_ip = 32'hC0A80101;
            external_ip = 32'h01010101;
            enable = 1;
            @(posedge clk);
            #1;


            enable = 0;
            internal_ip = 32'h0A000001;
            external_ip = 32'h08080808;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h01010101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Update Translation (Change mapping for a new internal address)", test_num);
            reset_dut();


            internal_ip = 32'hC0A80101;
            external_ip = 32'h01010101;
            enable = 1;
            @(posedge clk);
            #1;


            internal_ip = 32'h0A000005;
            external_ip = 32'hAC100001;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAC100001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Edge Case - All Ones Address", test_num);
            reset_dut();

            internal_ip = 32'hFFFFFFFF;
            external_ip = 32'hFFFFFFFF;
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Long-term stability after enable goes low", test_num);
            reset_dut();

            internal_ip = 32'hC0A80164;
            external_ip = 32'h2F2F2F2F;
            enable = 1;
            @(posedge clk);
            #1;

            enable = 0;
            internal_ip = 0;
            external_ip = 0;


            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h2F2F2F2F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
        input [31:0] expected_translated_ip;
        begin
            if (expected_translated_ip === (expected_translated_ip ^ translated_ip ^ expected_translated_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_ip=%h",
                         translated_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_ip=%h",
                         expected_translated_ip);
                $display("  Got:      translated_ip=%h",
                         translated_ip);
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
        $dumpvars(0,clk, enable, external_ip, internal_ip, translated_ip);
    end

endmodule
