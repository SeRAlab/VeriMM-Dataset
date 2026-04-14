`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg g;
    reg k;
    reg t;
    reg w;
    wire x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .g(g),
        .k(k),
        .t(t),
        .w(w),
        .x(x)
    );
    task testcase001;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0000;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase002;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0001;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b1);
end
    endtask

    task testcase003;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0010;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b1);
end
    endtask

    task testcase004;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0011;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase005;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0100;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b1);
end
    endtask

    task testcase006;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0101;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase007;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0110;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b1);
end
    endtask

    task testcase008;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b0111;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b1);
end
    endtask

    task testcase009;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1000;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase010;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1001;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase011;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1010;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase012;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1011;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase013;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1100;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase014;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1101;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b1);
end
    endtask

    task testcase015;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1110;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b0);
end
    endtask

    task testcase016;

begin
    test_num = test_num + 1;
    {g, w, k, t} = 4'b1111;
    $display("Test %0d: g=%b, w=%b, k=%b, t=%b", test_num, g, w, k, t);
    #1;

    check_outputs(1'b1);
end
    endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: x=%b",
                         x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%b",
                         expected_x);
                $display("  Got:      x=%b",
                         x);
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
