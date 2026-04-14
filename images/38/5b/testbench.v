`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (combinational circuit)
    reg nat_type;
    reg [4:0] private_ip;
    wire [4:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .nat_type(nat_type),
        .private_ip(private_ip),
        .public_ip(public_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Static NAT", test_num);
            rst_n = 0;
            nat_type = 0;
            private_ip = 5'b10101;
            #10 rst_n = 1;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic NAT - Initial Value", test_num);
            rst_n = 0;
            nat_type = 1;
            private_ip = 5'b00001;
            #10 rst_n = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic NAT - Second Increment", test_num);
            rst_n = 0;
            nat_type = 1;
            #10 rst_n = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mode Switching (Static -> Dynamic)", test_num);
            rst_n = 0;
            nat_type = 0;
            #10 rst_n = 1;
            #10;
            nat_type = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic NAT - Wrap Around Check", test_num);
            rst_n = 0;
            nat_type = 1;
            #10 rst_n = 1;

            for (i = 0; i <= 32; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Static NAT - Private IP Invariance", test_num);
            rst_n = 0;
            nat_type = 0;
            private_ip = 5'b00000;
            #10 rst_n = 1;
            #5 private_ip = 5'b11111;
            #5 private_ip = 5'b01010;
            #5;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat Testbench");
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
        input [4:0] expected_public_ip;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
