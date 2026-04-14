`timescale 1ns/1ps

module nat_translation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] nat_rule;
    reg [31:0] private_ip;
    wire [31:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_translation dut (
        .clk(clk),
        .nat_rule(nat_rule),
        .private_ip(private_ip),
        .public_ip(public_ip)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin


        nat_rule = 32'h0;
        private_ip = 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Basic Translation (Private A -> Public A)", test_num);


        nat_rule = 32'hC0A80101;
        private_ip = 32'h0A000001;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hC0A80101);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Translation with different IP address", test_num);

        nat_rule = 32'h08080808;
        private_ip = 32'hC0A8000A;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h08080808);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case - All Zeros", test_num);

        nat_rule = 32'h00000000;
        private_ip = 32'h00000000;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Boundary Case - All Ones", test_num);

        nat_rule = 32'hFFFFFFFF;
        private_ip = 32'hFFFFFFFF;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Sequential update check", test_num);


        nat_rule = 32'h11112222;
        private_ip = 32'hAAAAAAAA;
        @(posedge clk);
        #1;


        nat_rule = 32'h33334444;
        private_ip = 32'hBBBBBBBB;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h33334444);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Verify update happens on Clock Edge", test_num);

        nat_rule = 32'hDEADC0DE;
        private_ip = 32'h12345678;


        #1;
        if (public_ip === 32'hDEADC0DE) begin
             $display("Warning: Output updated before clock edge");
        end

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hDEADC0DE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_translation Testbench");
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
        input [31:0] expected_public_ip;
        begin
            if (expected_public_ip === (expected_public_ip ^ public_ip ^ expected_public_ip)) begin
                $display("PASS");
                $display("  Outputs: public_ip=%h",
                         public_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: public_ip=%h",
                         expected_public_ip);
                $display("  Got:      public_ip=%h",
                         public_ip);
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
        $dumpvars(0,clk, nat_rule, private_ip, public_ip);
    end

endmodule
