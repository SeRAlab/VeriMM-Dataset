`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dest_port;
    reg [3:0] src_port;
    wire accept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_port(dest_port),
        .src_port(src_port),
        .accept(accept)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Source port 0001 (Valid)", test_num);
        src_port = 4'b0001;
        dest_port = 4'b1010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Source port 0010 (Valid)", test_num);
        src_port = 4'b0010;
        dest_port = 4'b0101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Source port 0000 (Invalid)", test_num);
        src_port = 4'b0000;
        dest_port = 4'b1111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Source port 0011 (Invalid)", test_num);
        src_port = 4'b0011;
        dest_port = 4'b0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Source port 1111 (Invalid)", test_num);
        src_port = 4'b1111;
        dest_port = 4'b1001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Source port 1000 (Invalid)", test_num);
        src_port = 4'b1000;
        dest_port = 4'b0010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_accept;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accept === (expected_accept ^ accept ^ expected_accept)) begin
                $display("PASS");
                $display("  Outputs: accept=%b",
                         accept);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accept=%b",
                         expected_accept);
                $display("  Got:      accept=%b",
                         accept);
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
